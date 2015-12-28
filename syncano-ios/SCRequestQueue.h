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

@interface SCRequestQueue : NSObject

@property (nonatomic,retain) NSString *identifier;

- (instancetype)initWithIdentifier:(NSString *)identifier;

- (void)enqueueGETRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback;
- (void)enqueueUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback;
@end
