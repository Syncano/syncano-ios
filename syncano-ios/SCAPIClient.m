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
#import "AFNetworkReachabilityManager.h"

@interface SCAPIClient () <SCRequestQueueDelegate>
@property (nonatomic,copy) NSString *apiKey;
@property (nonatomic,copy) NSString *instanceName;
@property (nonatomic,retain) SCRequestQueue *requestQueue;
@property (nonatomic,retain) NSMutableArray *requestsBeingProcessed;
@property (nonatomic) NSInteger maxConcurentRequestsInQueue;
@property (nonatomic,retain) AFNetworkReachabilityManager *networkReachabilityManager;
@end

@implementation SCAPIClient

- (instancetype)initWithBaseURL:(NSURL *)url apiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    self = [self initWithBaseURL:url];
    if (self) {
        self.apiKey = apiKey;
        self.instanceName = instanceName;
        self.requestQueue = [[SCRequestQueue alloc] initWithIdentifier:[self identifier] delegate:self];
        self.maxConcurentRequestsInQueue = 2;
        self.requestsBeingProcessed = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.securityPolicy = [self syncanoSecurityPolicy];
        self.responseSerializer = [SCJSONResponseSerializer serializer];
        [self initializeReachabilityManager];
    }
    return self;
}

- (AFSecurityPolicy*)syncanoSecurityPolicy {
    AFSecurityPolicy* policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    policy.allowInvalidCertificates = NO;
    policy.validatesDomainName = NO;
    NSString *cerPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"certfile" ofType:@"der"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    policy.pinnedCertificates = @[certData];
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
    if ([SCUser currentUser]) {
        [hash appendString:[SCUser currentUser].userKey];
    }
    return [hash sc_MD5String];
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

@implementation SCAPIClient (Reachability)

- (void)initializeReachabilityManager {
    self.networkReachabilityManager = [AFNetworkReachabilityManager managerForDomain:kBaseURL];
    [self.networkReachabilityManager startMonitoring];
}

- (BOOL)reachable {
    return self.networkReachabilityManager.reachable;
}

@end
