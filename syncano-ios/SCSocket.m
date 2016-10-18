//
//  SCSocket.m
//  syncano-ios
//
//  Created by Jan Lipmann on 14/10/2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Syncano.h"
#import "SCSocket.h"
#import "SCAPIClient.h"

@implementation SCSocket

- (void)runWithMethod:(SocketRunMethod)method endpointName:(NSString *)endpointName parameters:(NSDictionary *)params completion:(SCCustomResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [Syncano sharedAPIClient];
    [self runWithMethod:method endpointName:endpointName parameters:params apiClient:apiClient completion:completion];
}


- (void)runWithMethod:(SocketRunMethod)method endpointName:(NSString *)endpointName parameters:(NSDictionary *)params apiClient:(SCAPIClient *)apiClient completion:(SCCustomResponseCompletionBlock)completion {
    NSString *path = [self resolvePathForEndpointWithName:endpointName];
    switch (method) {
        case SocketRunMethodPOST: {
            [apiClient POSTWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
                completion(responseObject,error);
            }];
            break; }
        case SocketRunMethodGET: {
            [apiClient GETWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
                completion(responseObject,error);
            }];
            break; }
        case SocketRunMethodPUT: {
            [apiClient PUTWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
                completion(responseObject,error);
            }];
            break; }
        case SocketRunMethodPATCH: {
            [apiClient PATCHWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
                completion(responseObject,error);
            }];
            break; }
        case SocketRunMethodDELETE: {
            [apiClient DELETEWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
                completion(responseObject,error);
            }];
            break; }
    }
    
}

- (NSString *)resolvePathForEndpointWithName:(NSString *)endpointName {
    return [NSString stringWithFormat:@"endpoints/sockets/%@",endpointName];
}



@end
