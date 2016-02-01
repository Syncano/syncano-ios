//
//  SCWebhook.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 28/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCWebhook.h"
#import "SCAPIClient.h"
#import "Syncano.h"
#import "SCWebhookResponseObject.h"


@implementation SCWebhook

+ (void)runWebhookWithName:(NSString *)name completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:nil usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}
+ (void)runWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:nil usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:payload usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}
+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookWithName:name withPayload:payload usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runPublicWebhookWithHash:(NSString *)hashTag name:(NSString *)name params:(NSDictionary *)params forInstanceName:(NSString *)instanceName completion:(SCWebhookCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"%@/webhooks/p/%@/%@/",instanceName,hashTag,name];
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];

    [self runPublicWebhookWithPath:path params:params usingAPIClient:apiClient completion:completion];
}

+ (void)runPublicWebhookWithURLString:(NSString *)urlString params:(NSDictionary *)params completion:(SCWebhookCompletionBlock)completion {
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    [self runPublicWebhookWithPath:@"" params:params usingAPIClient:apiClient completion:completion];
}

#pragma mark - Custom webhooks
+ (void)runCustomWebhookWithName:(NSString *)name completion:(SCCustomResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [[Syncano sharedAPIClient] copy];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self runCustomWebhookWithName:name withPayload:nil usingAPIClient:apiClient completion:completion];
}
+ (void)runCustomWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion {
    [self runCustomWebhookWithName:name withPayload:nil usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)runCustomWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCCustomResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [[Syncano sharedAPIClient] copy];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self runCustomWebhookWithName:name withPayload:payload usingAPIClient:apiClient completion:completion];
}
+ (void)runCustomWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion {
    [self runCustomWebhookWithName:name withPayload:payload usingAPIClient:syncano.apiClient completion:completion];
}


+ (void)runCustomPublicWebhookWithHash:(NSString *)hashTag
                            name:(NSString *)name
                          params:(NSDictionary *)params
                 forInstanceName:(NSString *)instanceName
                completion:(SCCustomResponseCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"%@/webhooks/p/%@/%@/",instanceName,hashTag,name];
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self runCustomPublicWebhookWithPath:path params:params usingAPIClient:apiClient completion:completion];
}
+ (void)runCustomPublicWebhookWithURLString:(NSString *)urlString
                               params:(NSDictionary *)params
                     completion:(SCCustomResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self runCustomPublicWebhookWithPath:@"" params:params usingAPIClient:apiClient completion:completion];
}

#pragma mark - Private methods
+ (void)runWebhookOnAPIClientWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCAPICompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"webhooks/%@/run/",name];
    NSDictionary *params = (payload) ? payload : nil;
    [apiClient postTaskWithPath:path params:params completion:completion];
}

+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCWebhookCompletionBlock)completion {
    [self runWebhookOnAPIClientWithName:name withPayload:payload usingAPIClient:apiClient completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            if(error) {
                completion(nil,error);
                return;
            }
            
            SCWebhookResponseObject *webhookResponseObject = [[SCWebhookResponseObject alloc] initWithJSONObject:responseObject];
            completion(webhookResponseObject,nil);
        }
    }];
}

+ (void)runCustomWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload usingAPIClient:(SCAPIClient *)apiClient completion:(SCCustomResponseCompletionBlock)completion {
    [self runWebhookOnAPIClientWithName:name withPayload:payload usingAPIClient:apiClient completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            if(error) {
                completion(nil,error);
                return;
            }
            
            completion(responseObject,nil);
        }
    }];
}

+ (void)runPublicWebhookWithPath:(NSString *)path params:(NSDictionary *)params usingAPIClient:(SCAPIClient*)apiClient completion:(SCWebhookCompletionBlock)completion {
    [apiClient POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            SCWebhookResponseObject *webhookResponseObject = [[SCWebhookResponseObject alloc] initWithJSONObject:responseObject];
            completion(webhookResponseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}

+ (void)runCustomPublicWebhookWithPath:(NSString *)path params:(NSDictionary *)params usingAPIClient:(SCAPIClient*)apiClient completion:(SCCustomResponseCompletionBlock)completion {
    [apiClient POST:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
}

@end
