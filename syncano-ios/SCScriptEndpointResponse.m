//
//  SCScriptEndpointResponse.m
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/8/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCScriptEndpointResponse.h"
#import "NSObject+SCParseHelper.h"

@implementation SCScriptEndpointResponse

- (instancetype)initWithJSONObject:(id)JSONObject {
    self = [super init];
    if (self) {
        self.status = [JSONObject[@"status"] sc_stringOrEmpty];
        self.duration = [JSONObject[@"duration"] sc_numberOrNil];
        self.result = [JSONObject[@"result"] sc_objectOrNil];
        self.executedAt = [JSONObject[@"executed_at"] sc_dateOrNil];
    }
    return self;
}

@end
