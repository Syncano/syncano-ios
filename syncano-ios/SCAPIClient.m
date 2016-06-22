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

/**
 @deprecated This method is deprecated. Please use initWithApiVersion:apiKey:instanceName: instead when initializing API Client to use it with Syncano
 */
- (instancetype)initWithBaseURL:(NSURL *)url apiKey:(NSString *)apiKey instanceName:(NSString *)instanceName DEPRECATED_MSG_ATTRIBUTE("Use initWithApiVersion:apiKey:instanceName: method instead.") {
    self = [self initWithBaseURL:url];
    if (self) {
        self.apiKey = apiKey;
        self.instanceName = instanceName;
        self.requestQueue = [[SCRequestQueue alloc] initWithIdentifier:[self identifier] delegate:self];
        self.maxConcurentRequestsInQueue = 2;
        self.requestsBeingProcessed = [NSMutableArray new];
        self.apiVersion = kDefaultAPIVersion;
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
    [self.requestQueue enqueueUploadRequestWithPath:path propertyName:propertyName fileData:fileData callback:completion];
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
            BOOL reachable = [self reachable];
            if (!reachable && request.save) {
                //TODO: we have to discuss if we want to make this request again and maybe here we should stop the queue until we reach internet connection?
            } else {
                if (completion) {
                    completion(task,responseObject,error);
                }
            }
        } else {
            if (completion) {
                completion(task,responseObject,error);
            }
        }
        [self requestHasFinishedProcessing:request];
    };
    
    if ([request isKindOfClass:[SCUploadRequest class]]) {
        SCUploadRequest *uploadRequest = (SCUploadRequest *)request;
        NSString *propertyName = uploadRequest.propertyName;
        NSData *fileData = uploadRequest.fileData;
        [self postUploadTaskWithPath:path propertyName:propertyName fileData:fileData completion:requestFinishedBlock];
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

- (NSURLSessionDataTask *)postUploadTaskWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(SCAPICompletionBlock)completion {
    [self authorizeRequest];
    NSURLSessionDataTask *task = [self POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:propertyName fileName:propertyName mimeType:[fileData mimeTypeByGuessing]];
        [formData appendPartWithFormData:fileData name:propertyName];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(task,responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(task,nil, error);
    }];
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
    if ([[payload allKeys] containsObject:SCPleaseParameterCacheKey]) {
        NSString *cacheKey = payload[SCPleaseParameterCacheKey];
        NSMutableDictionary *mutablePayload = [payload mutableCopy];
        [mutablePayload removeObjectForKey:SCPleaseParameterCacheKey];
        NSString *cacheKeyQueryString = [NSString stringWithFormat:@"%@=%@",SCPleaseParameterCacheKey,cacheKey];
        NSString *pathWithCacheKey = [path pathStringByAppendingQueryString:cacheKeyQueryString];
        if (completion) {
            completion(pathWithCacheKey,[NSDictionary dictionaryWithDictionary:mutablePayload]);
        }
    } else {
        if (completion) {
            completion(path,payload);
        }
    }
}

@end
