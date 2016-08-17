//
//  SCBatchResponseItem.m
//  syncano-ios
//
//  Created by Jan Lipmann on 03/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCBatchResponseItem.h"
#import "SCParseManager+SCDataObject.h"

@implementation SCBatchResponseItem

+ (SCBatchResponseItem *)itemWithJSONDictionary:(NSDictionary *)JSONDictionary classToParse:(Class)classToParse {
    SCBatchResponseItem *item = [[SCBatchResponseItem alloc] initWithJSONDictionary:JSONDictionary classToParse:classToParse];
    return item;
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)JSONDictionary classToParse:(Class)classToParse
{
    self = [super init];
    if (self) {
        self.classToParse = classToParse;
        self.code = JSONDictionary[@"code"];
        self.content = [self tryToParseContent:JSONDictionary[@"content"]];
    }
    return self;
}

- (id)tryToParseContent:(id)content {
    if (!self.classToParse) {
        return content;
    }
    if ([content isKindOfClass:[NSArray class]]) {
        return [[SCParseManager sharedSCParseManager] parsedObjectsOfClass:self.classToParse fromJSONObject:content];
    } else {
        return [[SCParseManager sharedSCParseManager] parsedObjectOfClass:self.classToParse fromJSONObject:content];
    }
}
@end
