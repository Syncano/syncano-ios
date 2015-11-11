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
#import "SCDataObject+Properties.h"



@implementation SCParseManager (SCDataObject)

- (id)parsedObjectOfClass:(__unsafe_unretained Class)objectClass fromJSONObject:(id)JSONObject {
    //TODO change to send error
    NSError *error;
    id parsedobject = [MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:JSONObject error:&error];
    [self resolveRelationsToObject:parsedobject withJSONObject:JSONObject];
    [self resolveFilesForObject:parsedobject withJSONObject:JSONObject];
    return parsedobject;
}

- (void)resolveRelationsToObject:(id)parsedObject withJSONObject:(id)JSONObject {
    NSDictionary *relations = [self relationsForClass:[parsedObject class]];
    for (NSString *relationKeyProperty in relations.allKeys) {
        SCClassRegisterItem *relationRegisteredItem = relations[relationKeyProperty];
        Class relatedClass = relationRegisteredItem.classReference;
        id relatedObject = [[relatedClass alloc] init];
        if (JSONObject[relationKeyProperty] != [NSNull null]) {
            NSNumber *relatedObjectId = JSONObject[relationKeyProperty][@"value"];
            if (relatedObjectId) {
                [relatedObject setValue:relatedObjectId forKey:@"objectId"];
                SCValidateAndSetValue(parsedObject, relationKeyProperty, relatedObject, YES, nil);
            }
        }
    }
}

- (void)resolveFilesForObject:(id)parsedObject withJSONObject:(id)JSONObject {
    for (NSString *key in [JSONObject allKeys]) {
        id object = JSONObject[key];
        if ([object isKindOfClass:[NSDictionary class]] && object[@"type"] && [object[@"type"] isEqualToString:@"file"]) {
            //TODO change to send error
            NSError *error;
            SCFile *file = [[SCFile alloc] initWithDictionary:object error:&error];
            SCValidateAndSetValue(parsedObject, key, file, YES, nil);
        }
    }
}

- (NSArray *)parsedObjectsOfClass:(__unsafe_unretained Class)objectClass fromJSONObject:(id)responseObject {
    NSArray *responseObjects = responseObject;
    NSMutableArray *parsedObjects = [[NSMutableArray alloc] initWithCapacity:responseObjects.count];
    for (NSDictionary *object in responseObjects) {
        [parsedObjects addObject:[self parsedObjectOfClass:objectClass fromJSONObject:object]];
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
    NSDictionary *relations = [self relationsForClass:[dataObject class]];
    if (relations.count > 0) {
        NSMutableDictionary *mutableSerialized = serialized.mutableCopy;
        for (NSString *relationProperty in relations.allKeys) {
            id relatedObject = [dataObject valueForKey:relationProperty];
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
    return serialized;
}


@end
