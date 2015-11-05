//
//  SCParseManager+SCLocalStorage.m
//  syncano-ios
//
//  Created by Jan Lipmann on 05/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCParseManager+SCLocalStorage.h"
#import <Mantle.h>
#import "SCDataObject.h"

@implementation SCParseManager (SCLocalStorage)
- (NSDictionary *)JSONRepresentationOfDataObject:(SCDataObject *)dataObject error:(NSError *__autoreleasing *)error {
    NSDictionary *serialized = [MTLJSONAdapter JSONDictionaryFromModel:dataObject error:nil];
    NSDictionary *relations = [self relationsForClass:[dataObject class]];
    if (relations.count > 0) {
        NSMutableDictionary *mutableSerialized = serialized.mutableCopy;
        for (NSString *relationProperty in relations.allKeys) {
            SCClassRegisterItem *registerItem = (SCClassRegisterItem*)relations[relationProperty];
            id relatedObject = [dataObject valueForKey:relationProperty];
            NSNumber *objectId = [relatedObject valueForKey:@"objectId"];
            if (objectId) {
                NSDictionary *relation = @{@"_type" : @"relation", @"objectId" : objectId , @"class" : registerItem.className};
                [mutableSerialized setObject:relation forKey:relationProperty];
            }
        }
        serialized = [NSDictionary dictionaryWithDictionary:mutableSerialized];
    }
    return serialized;
}

@end
