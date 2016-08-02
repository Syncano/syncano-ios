//
//  SCBatchRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 01/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCBatchRequest.h"

@implementation SCBatchRequest


+ (SCBatchRequest *)requestWithMethod:(SCRequestMethod)method payload:(NSDictionary *)payload {
    SCBatchRequest *request = [SCBatchRequest new];
    request.method = method;
    request.payload = payload;
    return request;
}

@end
