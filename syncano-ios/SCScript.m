//
//  SCScript.m
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/8/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCScript.h"
#import "SCAPIClient.h"
#import "SCAPIClient_SCAPIClient.h"
#import "Syncano.h"

@implementation SCScript

+ (void)runScriptWithId:(NSNumber *)scriptId params:(NSDictionary *)params completion:(SCScriptCompletionBlock)completion {
    [self runScriptWithId:scriptId params:params usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)runScriptWithId:(NSNumber *)scriptId params:(NSDictionary *)params onSyncano:(Syncano *)syncano completion:(SCScriptCompletionBlock)completion {
    [self runScriptWithId:scriptId params:params usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runScriptWithId:(NSNumber *)scriptId params:(NSDictionary *)params usingAPIClient:(SCAPIClient *)apiClient completion:(SCCodeBoxCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"snippets/scripts/%@/run/",scriptId];
    NSDictionary *payload = (params) ? @{@"payload" : params} : nil;
    SCAPIClient *apiClient_v1_1 = [[SCAPIClient alloc] initWithApiVersion:SCAPIVersion_1_1 apiKey:apiClient.apiKey instanceName:apiClient.instanceName];
    [apiClient_v1_1 POSTWithPath:path params:payload completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil,error);
            }
        } else {
            if (completion) {
                SCTrace *trace = [[SCTrace alloc] initWithJSONObject:responseObject andScriptIdentifier:scriptId];
                completion(trace,error);
            }
        }
    }];
}

@end
