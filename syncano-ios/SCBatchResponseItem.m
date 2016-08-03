//
//  SCBatchResponseItem.m
//  syncano-ios
//
//  Created by Jan Lipmann on 03/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCBatchResponseItem.h"

@implementation SCBatchResponseItem

+ (SCBatchResponseItem *)itemWithJSONDictionary:(NSDictionary *)JSONDictionary {
    SCBatchResponseItem *item = [[SCBatchResponseItem alloc] initWithJSONDictionary:JSONDictionary];
    return item;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)JSONDictionary
{
    self = [super init];
    if (self) {
        self.code = [JSONDictionary[@"code"] integerValue];
        self.content = JSONDictionary[@"content"];
    }
    return self;
}

@end
