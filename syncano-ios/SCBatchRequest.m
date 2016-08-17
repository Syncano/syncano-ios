//
//  SCBatchRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 01/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCBatchRequest.h"
#import "SCAPIClient.h"
#import "SCAPIClient_SCAPIClient.h"
#import "SCConstants.h"

@implementation SCBatchRequest


+ (SCBatchRequest *)requestWithMethod:(SCRequestMethod)method path:(NSString *)path payload:(NSDictionary *)payload {
    return [self requestWithMethod:method path:path payload:payload responseObjectClass:nil];
}

+ (SCBatchRequest *)requestWithMethod:(SCRequestMethod)method path:(NSString *)path payload:(NSDictionary *)payload responseObjectClass:(Class)responseObjectClass {
    SCBatchRequest *request = [SCBatchRequest new];
    request.method = method;
    request.path = path;
    request.payload = payload;
    request.responseObjectClass = responseObjectClass;
    return request;
}

- (NSDictionary *)encodedRequestForAPIClient:(SCAPIClient *)apiClient {
    NSMutableDictionary *encodedRequest = [NSMutableDictionary new];
    NSString *path = [NSString stringWithFormat:@"/%@/instances/%@/%@",[SCConstants versionStringForAPIVersion:apiClient.apiVersion],apiClient.instanceName,self.path];
    encodedRequest[@"path"] = path;
    encodedRequest[@"method"] = [SCConstants requestMethodToString:self.method];
    if (self.payload != nil) {
        encodedRequest[@"body"] = self.payload;
    }
    return [encodedRequest copy];
}

@end
