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

@protocol SCRequestQueueDelegate <NSObject>
- (void)requestQueue:(SCRequestQueue *)queue didSavedRequest:(SCRequest *)request;
@end

@interface SCRequestQueue : NSObject

@property (nonatomic,retain) NSString *identifier;
@property (nonatomic,readonly) BOOL hasRequests;

@property (nonatomic,assign) id<SCRequestQueueDelegate> delegate;

- (instancetype)initWithIdentifier:(NSString *)identifier delegate:(id<SCRequestQueueDelegate>)delegate;

- (void)enqueueGETRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueueUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback;

- (void)enqueueGETRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save;
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save;
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save;
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save;
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save;
- (void)enqueueUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback save:(BOOL)save;

- (SCRequest *)dequeueRequest;

@end
