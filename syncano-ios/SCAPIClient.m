//
//  SCAPIClient.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient.h"
#import "SCAPIClient_SCAPIClient.h"
#import "Syncano.h"
#import "SCJSONResponseSerializer.h"
#import "NSData+MimeType.h"
#import "SCRequest.h"
#import "NSString+MD5.h"
#import "SCRequest.h"
#import "SCUploadRequest.h"
#import "AFNetworkReachabilityManager.h"
#import "SCUser+UserDefaults.h"
#import "SCConstants.h"
#import "NSString+PathManipulations.h"

@interface SCAPIClient () <SCRequestQueueDelegate>
@end

@implementation SCAPIClient

- (instancetype)initWithApiVersion:(SCAPIVersion)apiVersion apiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    NSURL *baseURL = [SCConstants baseURLForAPIVersion:apiVersion];
    baseURL = [NSURL URLWithString:instanceName relativeToURL:baseURL];
    self = [self initWithBaseURL:baseURL];
    if (self) {
        self.apiKey = apiKey;
        self.instanceName = instanceName;
        self.requestQueue = [[SCRequestQueue alloc] initWithIdentifier:[self identifier] delegate:self];
        self.maxConcurentRequestsInQueue = 2;
        self.requestsBeingProcessed = [NSMutableArray new];
        self.apiVersion = apiVersion;
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.securityPolicy = [self syncanoSecurityPolicy];
        self.responseSerializer = [SCJSONResponseSerializer serializer];
        [self setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }];
        [self initializeReachabilityManager];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    SCAPIClient *apiClient = [[[self class] allocWithZone:zone] initWithApiVersion:self.apiVersion apiKey:self.apiKey instanceName:self.instanceName];
    return apiClient;
}

- (AFSecurityPolicy*)syncanoSecurityPolicy {
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    policy.allowInvalidCertificates = NO;
    policy.validatesDomainName = NO;
    NSString *cerPath = [[NSBundle bundleForClass:[self class]] pathForResource:kSCCertificateFileName ofType:nil];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    policy.pinnedCertificates = [NSSet setWithObject:certData];
    return policy;
}

- (NSString *)identifier {
    NSMutableString *hash = [NSMutableString new];
    if(self.apiKey != nil) {
        [hash appendString:self.apiKey];
    }
    if(self.instanceName != nil) {
        [hash appendString:self.instanceName];
    }
    if ([SCUser userKeyFromDefaults]) {
        [hash appendString:[SCUser userKeyFromDefaults]];
    }
    return [hash sc_MD5String];
}

+ (SCAPIClient *)apiClientForSyncano:(Syncano *)syncano {
    SCAPIClient *apiClient = [[self alloc] initWithApiVersion:kDefaultAPIVersion apiKey:syncano.apiKey instanceName:syncano.instanceName];
    return apiClient;
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

- (void)GETWithPathWithoutQueue:(NSString *)path params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodGET params:params callback:completion save:NO];
    [self runRequest:request];
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
    [self.requestQueue enqueuePOSTUploadRequestWithPath:path propertyName:propertyName fileData:fileData callback:completion];
    [self runQueue];
}

- (void)PATCHUploadWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion {
    [self.requestQueue enqueuePATCHUploadRequestWithPath:path propertyName:propertyName fileData:fileData callback:completion];
    [self runQueue];
}

#pragma mark - Request Queue Delegate -

- (void)requestQueue:(SCRequestQueue *)queue didSavedRequest:(SCRequest *)request {
    [self runQueue];
}

- (void)requestQueueDidEnqueuedRequestsFromDisk:(SCRequestQueue *)queue {
    [self runQueue];
}

#pragma mark  - Dequeue -
- (void)runQueue {
    if (self.maxConcurentRequestsInQueue <= 0 || self.requestsBeingProcessed.count < self.maxConcurentRequestsInQueue) {
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
    
    void (^requestFinishedBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error) = ^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            if (error.code == 429) {
                NSNumber *retryAfter = nil;
                if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
                    NSHTTPURLResponse *response =  (NSHTTPURLResponse *)task.response;
                    if ([response respondsToSelector:@selector(allHeaderFields)]) {
                        NSDictionary *allHeaderFields = response.allHeaderFields;
                        retryAfter = allHeaderFields[@"retry_after"];
                    }
                }
                if (retryAfter != nil) {
                    [self.requestQueue enqueueRequest:request onTop:YES];
                    [self.requestsBeingProcessed removeObject:request];
                    double delayInSeconds = retryAfter.doubleValue;
                    dispatch_queue_t backgroundQ = dispatch_queue_create("com.Syncano.backgroundDelay", NULL);
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, backgroundQ, ^(void){
                        [self runQueue];
                    });
                } else {
                    if (completion) {
                        completion(task,responseObject,error);
                    }
                    [self requestHasFinishedProcessing:request];
                }

            } else {
                BOOL reachable = [self reachable];
                if (!reachable && request.save) {
                    //TODO: we have to discuss if we want to make this request again and maybe here we should stop the queue until we reach internet connection?
                } else {
                    if (completion) {
                        completion(task,responseObject,error);
                    }
                }
                [self requestHasFinishedProcessing:request];
            }
        } else {
            if (completion) {
                completion(task,responseObject,error);
            }
            [self requestHasFinishedProcessing:request];
        }
    };
    
    if ([request isKindOfClass:[SCUploadRequest class]]) {
        SCUploadRequest *uploadRequest = (SCUploadRequest *)request;
        NSString *propertyName = uploadRequest.propertyName;
        NSData *fileData = uploadRequest.fileData;
        switch (method) {
            case SCRequestMethodPOST:
                [self postUploadTaskWithPath:path propertyName:propertyName fileData:fileData completion:requestFinishedBlock];
                break;
            case SCRequestMethodPATCH:
                [self patchUploadTaskWithPath:path propertyName:propertyName fileData:fileData completion:requestFinishedBlock];
                break;
            default: {
                NSError *error = [NSError errorWithDomain:SCRequestErrorDomain code:1001 userInfo:@{NSLocalizedFailureReasonErrorKey : @"Wrong request method used for file upload. Use PATCH or POST"}];
                if (requestFinishedBlock) {
                    requestFinishedBlock(nil,nil,error);
                }
                break;
            }
        }
    } else {
        switch (method) {
            case SCRequestMethodGET:
                [self getTaskWithPath:path params:params completion:requestFinishedBlock];
                break;
            case SCRequestMethodPOST:
                [self postTaskWithPath:path params:params completion:requestFinishedBlock];
                break;
            case SCRequestMethodPUT:
                [self putTaskWithPath:path params:params completion:requestFinishedBlock];
                break;
            case SCRequestMethodPATCH:
                [self patchTaskWithPath:path params:params completion:requestFinishedBlock];
                break;
            case SCRequestMethodDELETE:
                [self deleteTaskWithPath:path params:params completion:requestFinishedBlock];
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
                                  progress:nil
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
                                   progress:nil
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

- (NSURLSessionDataTask *)patchUploadTaskWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self PATCH:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:propertyName fileName:propertyName mimeType:[fileData mimeTypeByGuessing]];
        [formData appendPartWithFormData:fileData name:propertyName];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(task,responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(task,nil, error);
    }];
    return task;
}

- (NSURLSessionDataTask *)postUploadTaskWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion {
    NSDictionary *files = @{propertyName : fileData};
    return [self postUploadTaskWithPath:path params:nil files:files completion:completion];
}
    
- (NSURLSessionDataTask *)postUploadTaskWithPath:(NSString *)path params:(NSDictionary *)params files:(NSDictionary *)files completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSString *propertyName in files.allKeys) {
            NSData *fileData = files[propertyName];
            [formData appendPartWithFileData:fileData name:propertyName fileName:propertyName mimeType:[fileData mimeTypeByGuessing]];
            [formData appendPartWithFormData:fileData name:propertyName];
        }
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(task,responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(task,nil, error);
    }];
    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(id)parameters
      constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"PATCH" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:uploadProgress completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

@end

@implementation SCAPIClient (Reachability)

- (void)initializeReachabilityManager {
    self.networkReachabilityManager = [AFNetworkReachabilityManager managerForDomain:[[SCConstants baseURLForAPIVersion:kDefaultAPIVersion] absoluteString]];
    [self.networkReachabilityManager startMonitoring];
}

- (BOOL)reachable {
    return self.networkReachabilityManager.reachable;
}

@end

@implementation SCAPIClient (CacheKey)

- (void)checkAndResolveCacheKeyExistanceInPayload:(NSDictionary *)payload forPath:(NSString *)path completion:(void(^)(NSString *path, NSDictionary *payload))completion {
    if (completion == nil) {
        return;
    }
    if ([payload objectForKey:SCPleaseParameterCacheKey] != nil) {
        NSString *cacheKey = payload[SCPleaseParameterCacheKey];
        NSMutableDictionary *mutablePayload = [payload mutableCopy];
        [mutablePayload removeObjectForKey:SCPleaseParameterCacheKey];
        NSString *cacheKeyQueryString = [NSString stringWithFormat:@"%@=%@",SCPleaseParameterCacheKey,cacheKey];
        NSString *pathWithCacheKey = [path pathStringByAppendingQueryString:cacheKeyQueryString];
        completion(pathWithCacheKey,[mutablePayload copy]);
    } else {
            completion(path,payload);
    }
}

@end
