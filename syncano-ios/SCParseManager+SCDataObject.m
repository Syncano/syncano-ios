//
//  SCParseManager+SCDataObject.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 07/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCParseManager+SCDataObject.h"
#import "SCDataObject.h"
#import <objc/runtime.h>
#import "SCFile.h"
#import "SCGeoPoint.h"
#import "SCDataObject+Properties.h"
#import "SCRegisterManager.h"
#import "SCRelation.h"

@implementation SCParseManager (SCDataObject)

- (id)parsedObjectOfClass:(__unsafe_unretained Class)objectClass fromJSONObject:(id)JSONObject {
    id parsedobject = [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:JSONObject error:NULL];
    if(parsedobject == nil) {
        return parsedobject;//possible error in parsing
    }
    [self.referencesStore addDataObject:parsedobject];
    [self resolveRelationsToObject:parsedobject withJSONObject:JSONObject];
    [self resolveCustomObjectsForObject:parsedobject withJSONObject:JSONObject];
    return parsedobject;
}

- (id)relatedObjectOfClass:(__unsafe_unretained Class)objectClass fromJSONObject:(id)JSONObject {
    if(JSONObject[@"id"] != nil) {
        //object is downloaded
        return [self parsedObjectOfClass:objectClass fromJSONObject:JSONObject];
    }
    
    NSNumber *relatedObjectId = JSONObject[@"value"];
    if (relatedObjectId) {
        //we have only id
        id relatedObject = [self.referencesStore getObjectById:relatedObjectId];
        if (relatedObject) {
            return relatedObject;
        } else {
            relatedObject = [[objectClass alloc] init];
            [relatedObject setValue:relatedObjectId forKey:@"objectId"];
            [self.referencesStore addDataObject:relatedObject];
        }
        return relatedObject;
    }
    
    return nil;
}

- (void)resolveRelationsToObject:(id)parsedObject withJSONObject:(id)JSONObject {
    NSDictionary* relations = [SCRegisterManager relationsForClass:[parsedObject class]];
    for (NSString *relationKeyProperty in relations.allKeys) {
        SCClassRegisterItem *relationRegisteredItem = relations[relationKeyProperty];
        Class relatedClass = relationRegisteredItem.classReference;
        if (JSONObject[relationKeyProperty] != [NSNull null]) {
            id relatedObject = [self relatedObjectOfClass:relatedClass fromJSONObject:JSONObject[relationKeyProperty]];
            if (relatedObject != nil) {
                SCValidateAndSetValue(parsedObject, relationKeyProperty, relatedObject, YES, nil);
            }
        }
    }
}

/*DEPRECATED from 4.1.3 */
- (void)resolveFilesForObject:(id)parsedObject withJSONObject:(id)JSONObject DEPRECATED_MSG_ATTRIBUTE("Use resolveCustomObjectsForObject:withJSONObject: method instead.") {
    [self resolveCustomObjectsForObject:parsedObject withJSONObject:JSONObject];
}

- (void)resolveCustomObjectsForObject:(id)parsedObject withJSONObject:(id)JSONObject {
    for (NSString *key in [JSONObject allKeys]) {
        if ([parsedObject respondsToSelector:NSSelectorFromString(key)]) {
            id object = JSONObject[key];
            if ([object isKindOfClass:[NSDictionary class]] && object[@"type"]) {
                if ([object[@"type"] isEqualToString:@"file"]) {
                    //TODO change to send error
                    NSError *error = nil;
                    SCFile *file = [[SCFile alloc] initWithDictionary:object error:&error];
                    SCValidateAndSetValue(parsedObject, key, file, YES, nil);
                }
                if ([object[@"type"] isEqualToString:@"geopoint"]) {
                    //TODO change to send error
                    NSError *error = nil;
                    SCGeoPoint *geoPoint = [[SCGeoPoint alloc] initWithDictionary:object error:&error];
                    SCValidateAndSetValue(parsedObject, key, geoPoint, YES, nil);
                }
                if ([object[@"type"] isEqualToString:@"relation"]) {
                    NSString *targetValue = object[@"target"];
                    Class targetClass;
                    if (targetValue.length > 0) {
                        if ([targetValue isEqualToString:@"self"]) {
                            targetClass  = [parsedObject class];
                        } else {
                            targetClass = [SCRegisterManager classForAPIClassName:targetValue];
                        }
                    }
                    NSError *error = nil;
                    SCRelation *relation = [[SCRelation alloc] initWithDictionary:object error:&error targetClass:targetClass];
                    SCValidateAndSetValue(parsedObject, key, relation, YES, nil);
                }
            }
        }
    }
}


- (NSArray *)parsedObjectsOfClass:(__unsafe_unretained Class)objectClass fromJSONObject:(id)responseObject {
    NSArray *responseObjects = responseObject;
    NSMutableArray *parsedObjects = [[NSMutableArray alloc] initWithCapacity:responseObjects.count];
    for (NSDictionary *object in responseObjects) {
        id result = [self parsedObjectOfClass:objectClass fromJSONObject:object];
        [parsedObjects addObject:result];
    }
    return [NSArray arrayWithArray:parsedObjects];
}

- (void)fillObject:(SCDataObject *)object withDataFromJSONObject:(id)responseObject {
    id newParsedObject = [self parsedObjectOfClass:[object class] fromJSONObject:responseObject];
    [object mergeValuesForKeysFromModel:newParsedObject];
}

- (NSDictionary *)JSONSerializedDictionaryFromDataObject:(SCDataObject *)dataObject error:(NSError *__autoreleasing *)error {
    NSDictionary *serialized = [MTLJSONAdapter JSONDictionaryFromModel:dataObject error:nil];
    /**
     *  Temporary remove non saved relations
     */
    NSDictionary *relations = [SCRegisterManager relationsForClass:[dataObject class]];
    if (relations.count > 0) {
        NSMutableDictionary *mutableSerialized = serialized.mutableCopy;
        for (NSString *relationProperty in relations.allKeys) {
            id relatedObject = [dataObject valueForKey:relationProperty];
            // relatedObject == nil means no relation was set at all
            // and we want to handle only ones that were set but were not saved
            if (relatedObject == nil) {
                [mutableSerialized setObject:[NSNull null] forKey:relationProperty];
                continue;
            }
            NSNumber *objectId = [relatedObject valueForKey:@"objectId"];
            if (objectId) {
                [mutableSerialized setObject:objectId forKey:relationProperty];
            } else {
                if (error != NULL) {
                    NSDictionary *userInfo = @{
                                               NSLocalizedDescriptionKey: NSLocalizedString(@"Unsaved relation", @""),
                                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"You can not add reference for unsaved object",@""),
                                               };
                    *error = [NSError errorWithDomain:@"SCParseManagerErrorDomain" code:1 userInfo:userInfo];
                }
                [mutableSerialized removeObjectForKey:relationProperty];
            }
        }
        serialized = [NSDictionary dictionaryWithDictionary:mutableSerialized];
    }
    
    
    //Remove SCFileProperties
    NSArray *fileProperties = [[dataObject class] propertiesNamesOfFileClass];
    if (fileProperties.count > 0) {
        NSMutableDictionary *mutableSerialized = serialized.mutableCopy;
        for (NSString *fileProperty in fileProperties) {
            [mutableSerialized removeObjectForKey:fileProperty];
        }
        serialized = [NSDictionary dictionaryWithDictionary:mutableSerialized];
    }
    
    
    //Add SCRelations
    NSArray *scRelationsProperties = [[dataObject class] propertiesNamesOfSCRelationClass];
    if (scRelationsProperties.count > 0) {
        NSMutableDictionary *mutableSerialized = serialized.mutableCopy;
        for (NSString *scRelationProperty in scRelationsProperties) {
            SCRelation *relation = (SCRelation *)[dataObject valueForKey:scRelationProperty];
            if (relation != nil) {
                NSArray *arrayRepresentation = [relation arrayRepresentation];
                mutableSerialized[scRelationProperty] = arrayRepresentation;
            } else {
                mutableSerialized[scRelationProperty] = [NSNull null];
            }
        }
        serialized = [NSDictionary dictionaryWithDictionary:mutableSerialized];
    }
    
    return serialized;
}
@end
