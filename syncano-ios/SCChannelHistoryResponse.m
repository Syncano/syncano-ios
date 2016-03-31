//
//  SCChannelHistoryResponse.m
//  syncano-ios
//
//  Created by Jan Lipmann on 16/03/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCChannelHistoryResponse.h"
#import "NSObject+SCParseHelper.h"

@implementation SCChannelHistoryResponse

- (instancetype)initWithJSONObject:(id)JSONObject {
    self = [super init];
    if (self) {
        self.prev = [JSONObject[@"prev"] sc_stringOrEmpty];
        self.next = [JSONObject[@"prev"] sc_stringOrEmpty];
        self.objects = [self parsedObjects:[JSONObject[@"objects"] sc_arrayOrNil]];
    }
    return self;
}

- (NSArray<SCChannelNotificationMessage*>*)parsedObjects:(NSArray *)objects {
    NSMutableArray *parsedObjects = [NSMutableArray new];
    for (id JSONObject in objects) {
        SCChannelNotificationMessage *message = [[SCChannelNotificationMessage alloc] initWithJSONObject:JSONObject];
        [parsedObjects addObject:message];
    }
    return parsedObjects;
}

@end
