//
//  SCScriptEndpoint.m
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/8/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCScriptEndpoint.h"
#import "SCAPIClient.h"
#import "Syncano.h"

SCAPIVersion const kScriptEndpointDefaultAPIVersion = SCAPIVersion_1_1;

@interface SCScriptEndpoint ()
+ (void)runScriptEndpointOnAPIClientWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCAPICompletionBlock)completion;
+ (void)runScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCScriptEndpointCompletionBlock)completion;

+ (void)runPublicScriptEndpointWithPath:(NSString *)path payload:(NSDictionary *)payload usingAPIClient:(SCAPIClient*)apiClient completion:(SCScriptEndpointCompletionBlock)completion;

+ (void)runCustomScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCCustomResponseCompletionBlock)completion;
+ (void)runCustomPublicScriptEndpointWithPath:(NSString *)path payload:(NSDictionary *)payload usingAPIClient:(SCAPIClient*)apiClient completion:(SCCustomResponseCompletionBlock)completion;

+ (NSString *)pathForRunningScriptEndpointWithName:(NSString *)name;
+ (NSString *)pathForPublicScriptEndpointWithHash:(NSString *)hash name:(NSString *)name instanceName:(NSString *)instanceName;
@end

@implementation SCScriptEndpoint

#pragma mark - Public

+ (void)runScriptEndpointWithName:(NSString *)name completion:(SCScriptEndpointCompletionBlock)completion {
    [self runScriptEndpointWithName:name withPayload:nil usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)runScriptEndpointWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCScriptEndpointCompletionBlock)completion {
    [self runScriptEndpointWithName:name withPayload:nil usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCScriptEndpointCompletionBlock)completion {
    [self runScriptEndpointWithName:name withPayload:payload usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)runScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCScriptEndpointCompletionBlock)completion {
    [self runScriptEndpointWithName:name withPayload:payload usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runPublicScriptEndpointWithHash:(NSString *)hashTag name:(NSString *)name payload:(NSDictionary *)payload forInstanceName:(NSString *)instanceName completion:(SCScriptEndpointCompletionBlock)completion {
    NSString *path = [self pathForPublicScriptEndpointWithHash:hashTag name:name instanceName:instanceName];
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[SCConstants baseURLForAPIVersion:kScriptEndpointDefaultAPIVersion]];
    [self runPublicScriptEndpointWithPath:path payload:payload usingAPIClient:apiClient completion:completion];
}

+ (void)runPublicScriptEndpointWithURLString:(NSString *)urlString payload:(NSDictionary *)payload completion:(SCScriptEndpointCompletionBlock)completion {
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    [self runPublicScriptEndpointWithPath:@"" payload:payload usingAPIClient:apiClient completion:completion];
}

#pragma mark - Custom webhooks

+ (void)runCustomScriptEndpointWithName:(NSString *)name completion:(SCCustomResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [[Syncano sharedAPIClient] copy];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self runCustomScriptEndpointWithName:name withPayload:nil usingAPIClient:apiClient completion:completion];
}

+ (void)runCustomScriptEndpointWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion {
    [self runCustomScriptEndpointWithName:name withPayload:nil usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runCustomScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCCustomResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [[Syncano sharedAPIClient] copy];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self runCustomScriptEndpointWithName:name withPayload:payload usingAPIClient:apiClient completion:completion];
}

+ (void)runCustomScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion {
    [self runCustomScriptEndpointWithName:name withPayload:payload usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runCustomPublicScriptEndpointWithHash:(NSString *)hashTag name:(NSString *)name payload:(NSDictionary *)payload forInstanceName:(NSString *)instanceName completion:(SCCustomResponseCompletionBlock)completion {
    NSString *path = [self pathForPublicScriptEndpointWithHash:hashTag name:name instanceName:instanceName];
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[SCConstants baseURLForAPIVersion:kScriptEndpointDefaultAPIVersion]];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self runPublicScriptEndpointWithPath:path payload:payload usingAPIClient:apiClient completion:completion];
}

+ (void)runCustomPublicScriptEndpointWithURLString:(NSString *)urlString payload:(NSDictionary *)payload completion:(SCCustomResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self runCustomPublicScriptEndpointWithPath:@"" payload:payload usingAPIClient:apiClient completion:completion];
}

#pragma mark - Private

+ (void)runScriptEndpointOnAPIClientWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCAPICompletionBlock)completion {
    NSString *path = [self pathForRunningScriptEndpointWithName:name];
    [apiClient postTaskWithPath:path params:payload completion:completion];
}

+ (void)runScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCScriptEndpointCompletionBlock)completion {
    [self runScriptEndpointOnAPIClientWithName:name withPayload:payload usingAPIClient:apiClient completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            if(error) {
                completion(nil,error);
                return;
            }
            
            SCScriptEndpointResponse *response = [[SCScriptEndpointResponse alloc] initWithJSONObject:responseObject];
            completion(response,nil);
        }
    }];
}

+ (void)runCustomScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCCustomResponseCompletionBlock)completion {
    [self runScriptEndpointOnAPIClientWithName:name withPayload:payload usingAPIClient:apiClient completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            if(error) {
                completion(nil,error);
                return;
            }
            completion(responseObject,nil);
        }
    }];
}

+ (void)runPublicScriptEndpointWithPath:(NSString *)path payload:(NSDictionary *)payload usingAPIClient:(SCAPIClient*)apiClient completion:(SCScriptEndpointCompletionBlock)completion {
    [apiClient POST:path parameters:payload success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            SCScriptEndpointResponse *response = [[SCScriptEndpointResponse alloc] initWithJSONObject:responseObject];
            completion(response,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}

+ (void)runCustomPublicScriptEndpointWithPath:(NSString *)path payload:(NSDictionary *)payload usingAPIClient:(SCAPIClient*)apiClient completion:(SCCustomResponseCompletionBlock)completion {
    [apiClient POST:path parameters:payload success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}

NSString *const kSyncanoScriptEndpointPath = @"endpoints/scripts";

+ (NSString *)pathForRunningScriptEndpointWithName:(NSString *)name {
    NSString *path = [NSString stringWithFormat:@"%@/%@/run/",kSyncanoScriptEndpointPath,name];
    return path;
}

+ (NSString *)pathForPublicScriptEndpointWithHash:(NSString *)hash name:(NSString *)name instanceName:(NSString *)instanceName {
    NSString *path = [NSString stringWithFormat:@"%@/%@/p/%@/%@/",kSyncanoScriptEndpointPath,instanceName,hash,name];
    return path;
}

@end
