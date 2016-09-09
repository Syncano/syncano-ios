//
//  SCParseManager+SCDevice.m
//  syncano-ios
//
//  Created by Jan Lipmann on 19/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCParseManager+SCDevice.h"
#import "MTLJSONAdapter.h"
#import "SCDevice.h"

@implementation SCParseManager (SCDevice)

- (id)parsedDeviceObjectFromJSONObject:(id)JSONObject error:(NSError**)error {
    id parsedobject = [MTLJSONAdapter modelOfClass:[SCDevice class] fromJSONDictionary:JSONObject error:error];
    return parsedobject;
}

- (NSArray<SCDevice *> *)parsedDevicesFromJSONObject:(id)responseObject error:(NSError**)error {
    NSArray *responseObjects = responseObject;
    NSMutableArray *parsedObjects = [[NSMutableArray alloc] initWithCapacity:responseObjects.count];
    for (NSDictionary *object in responseObjects) {
        NSError *parseError;
        id result = [self parsedDeviceObjectFromJSONObject:object error:&parseError];
        if (parseError != nil) {
            *error = parseError;
        }
        if (result != nil) {
            [parsedObjects addObject:result];
        }
    }
    return [parsedObjects copy];
}
@end
