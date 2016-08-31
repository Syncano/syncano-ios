//
//  SCRequestCacheManager.h
//  syncano-ios
//
//  Created by Jan Lipmann on 07/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMacros.h"
#import "SCConstants.h"

@class SCRequest,SCRequestQueue;

NS_ASSUME_NONNULL_BEGIN

@protocol SCRequestQueueDelegate <NSObject>
- (void)requestQueue:(SCRequestQueue *)queue didSavedRequest:(SCRequest *)request;
- (void)requestQueueDidEnqueuedRequestsFromDisk:(SCRequestQueue *)queue;
@end

@interface SCRequestQueue : NSObject

@property (nullable,nonatomic,retain) NSString *identifier;
@property (nonatomic,readonly) BOOL hasRequests;

@property (nullable,nonatomic,assign) id<SCRequestQueueDelegate> delegate;

/**
 *  Initializes SCRequestQueue with identifier and delegate
 *
 *  @param identifier request identifier
 *  @param delegate   assigned delegate
 *
 *  @return SCRequestQueue
 */
- (instancetype)initWithIdentifier:(NSString *)identifier delegate:(id<SCRequestQueueDelegate>)delegate;
/**
 *  Enqueues GET request
 *
 *  @param path     URI of the request
 *  @param params   parameters
 *  @param callback callback block
 */
- (void)enqueueGETRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback;

/**
 *  Enquques POST request
 *
 *  @param path     URI of the request
 *  @param params   parameters
 *  @param callback callback block
 */
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback;

/**
 *  Enquques PATCH request
 *
 *  @param path     URI of the request
 *  @param params   parameters
 *  @param callback callback block
 */
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback;

/**
 *  Enquques DELETE request
 *
 *  @param path     URI of the request
 *  @param params   parameters
 *  @param callback callback block
 */
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback;

/**
 *  Enquques PUT request
 *
 *  @param path     URI of the request
 *  @param params   parameters
 *  @param callback callback block
 */
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback;

/**
 *  Enqueues POST upload request
 *
 *  @param path         URI of the request
 *  @param propertyName property (variable) name of a file
 *  @param fileData     NSData representation of a file
 *  @param callback     callback block
 */
- (void)enqueuePOSTUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(nullable SCAPICompletionBlock)callback;

/**
 *  Enqueues PATCH upload request
 *
 *  @param path         URI of the request
 *  @param propertyName property (variable) name of a file
 *  @param fileData     NSData representation of a file
 *  @param callback     callback block
 */
- (void)enqueuePATCHUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(nullable SCAPICompletionBlock)callback;

/**
 *  Enqueues GET request and store it on disk
 *
 *  @param path     URI of the request
 *  @param params   parmeters
 *  @param callback callback block
 *  @param save     boolean which determines if this request should be stored on disk
 */
- (void)enqueueGETRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;

/**
 *  Enqueues POST request and store it on disk
 *
 *  @param path     URI of the request
 *  @param params   parmeters
 *  @param callback callback block
 *  @param save     boolean which determines if this request should be stored on disk
 */
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;

/**
 *  Enqueues PATCH request and store it on disk
 *
 *  @param path     URI of the request
 *  @param params   parmeters
 *  @param callback callback block
 *  @param save     boolean which determines if this request should be stored on disk
 */
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;

/**
 *  Enqueues DELETE request and store it on disk
 *
 *  @param path     URI of the request
 *  @param params   parmeters
 *  @param callback callback block
 *  @param save     boolean which determines if this request should be stored on disk
 */
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;

/**
 *  Enqueues PUT request and store it on disk
 *
 *  @param path     URI of the request
 *  @param params   parmeters
 *  @param callback callback block
 *  @param save     boolean which determines if this request should be stored on disk
 */
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(nullable NSDictionary *)params callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;

/**
 *  Enqueues POST upload request and store it on disk
 *
 *  @param path         URI of the request
 *  @param propertyName property (variable) name of a file
 *  @param fileData     NSData representation of a file
 *  @param callback     callback block
 *  @param save         boolean which determines if this request should be stored on disk
 */
- (void)enqueuePOSTUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;

/**
 *  Enqueues PATCH upload request and store it on disk
 *
 *  @param path         URI of the request
 *  @param propertyName property (variable) name of a file
 *  @param fileData     NSData representation of a file
 *  @param callback     callback block
 *  @param save         boolean which determines if this request should be stored on disk
 */
- (void)enqueuePATCHUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;


- (void)enqueueRequest:(SCRequest *)request onTop:(BOOL)onTop;

/**
 *  Dequeues request from queue
 *
 *  @return dequeued SCRequest
 */
- (nullable SCRequest *)dequeueRequest;

@end
NS_ASSUME_NONNULL_END