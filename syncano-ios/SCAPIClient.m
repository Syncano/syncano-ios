//
//  SCAPIClient.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient.h"
#import "Syncano.h"
#import "SCJSONResponseSerializer.h"
#import "NSData+MimeType.h"
#import "SCRequest.h"
#import "SCRequestQueue.h"
#import "NSString+MD5.h"
#import "SCRequest.h"
#import "SCUploadRequest.h"

@interface SCAPIClient ()
@property (nonatomic,copy) NSString *apiKey;
@property (nonatomic,copy) NSString *instanceName;
@property (nonatomic,retain) SCRequestQueue *requestQueue;
@property (nonatomic,retain) NSMutableArray *requestsBeingProcessed;
@property (nonatomic) NSInteger maxConcurentRequestInQueue;
@end

@implementation SCAPIClient

- (instancetype)initWithBaseURL:(NSURL *)url apiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    self = [self initWithBaseURL:url];
    if (self) {
        self.apiKey = apiKey;
        self.instanceName = instanceName;
        self.requestQueue = [[SCRequestQueue alloc] initWithIdentifier:[self identifier]];
        self.maxConcurentRequestInQueue = 2;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.securityPolicy.allowInvalidCertificates = YES;
        self.securityPolicy.validatesDomainName = NO;
        self.responseSerializer = [SCJSONResponseSerializer serializer];
    }
    return self;
}

- (NSString *)identifier {
    NSMutableString *hash = [NSMutableString new];
    [hash appendString:self.apiKey];
    [hash appendString:self.instanceName];
    if ([SCUser currentUser]) {
        [hash appendString:[SCUser currentUser].userKey];
    }
    return [hash MD5String];
}

+ (SCAPIClient *)apiClientForSyncano:(Syncano *)syncano {
    NSURL *instanceURL = [NSURL URLWithString:syncano.instanceName relativeToURL:[NSURL URLWithString:kBaseURL]];
    SCAPIClient *apiClient = [[SCAPIClient alloc] initWithBaseURL:instanceURL apiKey:syncano.apiKey instanceName:syncano.instanceName];
    return apiClient;
}

- (void)setSocialAuthTokenKey:(NSString *)authToken {
    [self.requestSerializer setValue:[NSString stringWithFormat:@"token %@",authToken] forHTTPHeaderField:@"Authorization"];
}

- (void)authorizeRequest {
    NSString *apiKey = (self.apiKey.length > 0) ? self.apiKey : [Syncano getApiKey];
   [self.requestSerializer setValue:apiKey forHTTPHeaderField:@"X-API-KEY"];
    if ([SCUser currentUser]) {
        NSString *userKey = [SCUser currentUser].userKey;
        [self.requestSerializer setValue:userKey forHTTPHeaderField:@"X-USER-KEY"];
    }
}

#pragma mark  - Enqueue -


- (void)GETWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self.requestQueue enqueueGETRequestWithPath:path params:params callback:completion];
    [self runQueue];
}

- (void)POSTWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self.requestQueue enqueuePOSTRequestWithPath:path params:params callback:completion];
    [self runQueue];
}

- (void)PUTWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self.requestQueue enqueuePUTRequestWithPath:path params:params callback:completion];
    [self runQueue];
}

- (void)PATCHWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    
    [self.requestQueue enqueuePATCHRequestWithPath:path params:params callback:completion];
    [self runQueue];
}

- (void)DELETEWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self.requestQueue enqueueDELETERequestWithPath:path params:params callback:completion];
    [self runQueue];
}

- (void)POSTUploadWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion {
    [self.requestQueue enqueueUploadRequestWithPath:path propertyName:propertyName fileData:fileData callback:completion];
    [self runQueue];
}


#pragma mark  - Dequeue -

- (NSMutableArray *)requestsBeingProcessed {
    if (!_requestsBeingProcessed) {
        _requestsBeingProcessed = [NSMutableArray new];
    }
    return _requestsBeingProcessed;
}

- (void)runQueue {
    if (self.requestsBeingProcessed.count < self.maxConcurentRequestInQueue) {
        [self dequeueNextRequest];
    }
}

- (void)dequeueNextRequest {
    if (self.requestQueue.hasRequests) {
        SCRequest *request = [self.requestQueue dequeueRequest];
        [self.requestsBeingProcessed addObject:request];
        [self runRequest:request];
    }
}

- (void)runRequest:(SCRequest *)request {
    SCRequestMethod method = request.method;
    NSString *path = request.path;
    NSDictionary *params = request.params;
    SCAPICompletionBlock completion = request.callback;
    
    if ([request isKindOfClass:[SCUploadRequest class]]) {
        SCUploadRequest *uploadRequest = (SCUploadRequest *)request;
        NSString *propertyName = uploadRequest.propertyName;
        NSData *fileData = uploadRequest.fileData;
        [self postUploadTaskWithPath:path propertyName:propertyName fileData:fileData completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            if (completion) {
                completion(task,responseObject,error);
            }
            [self requestHasFinishedProcessing:uploadRequest];
        }];
    } else {
        switch (method) {
            case SCRequestMethodGET: {
                [self getTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    if (completion) {
                        completion(task,responseObject,error);
                    }
                    [self requestHasFinishedProcessing:request];
                }];}
                break;
            case SCRequestMethodPOST: {
                [self postTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    if (completion) {
                        completion(task,responseObject,error);
                    }
                    [self requestHasFinishedProcessing:request];
                }];}
                break;
            case SCRequestMethodPUT: {
                [self putTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    if (completion) {
                        completion(task,responseObject,error);
                    }
                    [self requestHasFinishedProcessing:request];
                }];}
                break;
            case SCRequestMethodPATCH: {
                [self patchTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    if (completion) {
                        completion(task,responseObject,error);
                    }
                    [self requestHasFinishedProcessing:request];
                }];}
                break;
            case SCRequestMethodDELETE: {
                [self deleteTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    if (completion) {
                        completion(task,responseObject,error);
                    }
                    [self requestHasFinishedProcessing:request];
                }];}
                break;
            default:
                break;
        }
    }

}

- (void)requestHasFinishedProcessing:(SCRequest *)request {
    [self.requestsBeingProcessed removeObject:request];
    [self runQueue];
}

- (NSURLSessionDataTask *)getTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self GET:path
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       completion(task,responseObject, nil);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(task,nil, error);
                                   }];
    
    return task;
}

- (NSURLSessionDataTask *)postTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self POST:path
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       completion(task,responseObject, nil);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(task,nil, error);
                                   }];
    
    return task;
}

- (NSURLSessionDataTask *)putTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self PUT:path
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        completion(task,responseObject, nil);
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        completion(task,nil, error);
                                    }];
    
    return task;
}

- (NSURLSessionDataTask *)patchTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    

    NSURLSessionDataTask *task = [self PATCH:path
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       completion(task,responseObject, nil);
                                   } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       completion(task,nil, error);
                                   }];
    
    return task;
}

- (NSURLSessionDataTask *)deleteTaskWithPath:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];

    NSURLSessionDataTask *task = [self DELETE:path
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        completion(task,responseObject, nil);
                                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        completion(task,nil, error);
                                    }];
    
    return task;
}

- (NSURLSessionDataTask *)postUploadTaskWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:propertyName fileName:propertyName mimeType:[fileData mimeTypeByGuessing]];
        [formData appendPartWithFormData:fileData name:propertyName];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(task,responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(task,nil, error);
    }];
    return task;
}

@end
