//
//  SCParseManager+SCLocalStorage.m
//  syncano-ios
//
//  Created by Jan Lipmann on 05/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCParseManager+SCLocalStorage.h"
#import "Mantle.h"
#import "SCDataObject.h"
#import "SCRegisterManager.h"

@implementation SCParseManager (SCLocalStorage)
- (NSDictionary *)JSONRepresentationOfDataObject:(SCDataObject *)dataObject error:(NSError *__autoreleasing *)error {
    NSDictionary *serialized = [MTLJSONAdapter JSONDictionaryFromModel:dataObject error:nil];
    NSDictionary *relations = [SCRegisterManager relationsForClass:[dataObject class]];
    if (relations.count > 0) {
        NSMutableDictionary *mutableSerialized = serialized.mutableCopy;
        for (NSString *relationProperty in relations.allKeys) {
            SCClassRegisterItem *registerItem = (SCClassRegisterItem*)relations[relationProperty];
            SCDataObject *relatedObject = (SCDataObject *)[dataObject valueForKey:relationProperty];
            if ([relatedObject isKindOfClass:[SCDataObject class]]) {
                NSNumber *objectId = relatedObject.objectId;
                if (objectId) {
                    NSDictionary *relation = @{@"_type" : @"relation", @"objectId" : objectId , @"class" : registerItem.className};
                    [mutableSerialized setObject:relation forKey:relationProperty];
                }
            }
        }
        serialized = [NSDictionary dictionaryWithDictionary:mutableSerialized];
    }
    return serialized;
}

- (SCDataObject *)parsedObjectOfClassWithName:(NSString *)className fromJSON:(NSDictionary *)JSONDictionary error:(NSError *__autoreleasing *)error {
    NSError *parsingError = nil;
    Class objectClass = NSClassFromString(className);
    SCDataObject * parsedobject = (SCDataObject *)[MTLJSONAdapter modelOfClass:objectClass fromJSONDictionary:JSONDictionary error:&parsingError];
    if (parsingError) {
        *error = parsingError;
    }
    return parsedobject;
}

@end
