//
//  SCAPIClient.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "AFNetworking/AFHTTPSessionManager.h"
#import "SCConstants.h"

@class Syncano, SCRequest;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Base class for API calls
 */
@interface SCAPIClient : AFHTTPSessionManager

/**
 *  Creates API Client for provided Syncano instance
 *
 *  @param syncano Syncano instance
 *
 *  @return SCAPIClient object
 */
+ (SCAPIClient *)apiClientForSyncano:(Syncano *)syncano;

/**
 *  "Abstract" method to GET method call added to queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (void)GETWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to GET method call
 *  This version doesn't put requests into queue, and launched them immediately
 *  Used for channels, which are making requests lasting up to 5 minutes
 *  And we don't want them blocking other requests from being sent
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (void)GETWithPathWithoutQueue:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to POST method call added to queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (void)POSTWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to PUT method call added to queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (void)PUTWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to PATCH method call added to queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (void)PATCHWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to DELETE method call added to queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return NSURLSessionDataTask object
 */
- (void)DELETEWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to upload file method call added to queue with POST method
 *
 *  @param path         path to request endpoint
 *  @param propertyName name of a file variable name inside a class
 *  @param fileData     NSData file representation
 *  @param completion   completion block
 */
- (void)POSTUploadWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to upload file method call added to queue with PATCH method
 *
 *  @param path         path to request endpoint
 *  @param propertyName name of a file variable name inside a class
 *  @param fileData     NSData file representation
 *  @param completion   completion block
 */
- (void)PATCHUploadWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to GET method call without queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (NSURLSessionDataTask *)getTaskWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to POST method call without queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (NSURLSessionDataTask *)postTaskWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to PUT method call without queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (NSURLSessionDataTask *)putTaskWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to PATCH method call without queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return void
 */
- (NSURLSessionDataTask *)patchTaskWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

/**
 *  "Abstract" method to DELETE method call without queue
 *
 *  @param path       path to request endpoint
 *  @param params     NSDictionary with params for request
 *  @param completion SCAPICompletionBlock completion callback block
 *
 *  @return NSURLSessionDataTask object
 */
- (NSURLSessionDataTask *)deleteTaskWithPath:(NSString *)path params:(nullable NSDictionary *)params completion:(nullable SCAPICompletionBlock)completion;

- (NSURLSessionDataTask *)postUploadTaskWithPath:(NSString *)path params:(nullable NSDictionary *)params files:(NSDictionary *)files completion:(SCAPICompletionBlock)completion;

@end

@interface SCAPIClient (Reachability)
- (void)initializeReachabilityManager;
- (BOOL)reachable;
@end

@interface SCAPIClient (CacheKey)
- (void)checkAndResolveCacheKeyExistanceInPayload:(NSDictionary *)payload forPath:(NSString *)path completion:(void(^)(NSString *path, NSDictionary *payload))completion;
@end
NS_ASSUME_NONNULL_END
