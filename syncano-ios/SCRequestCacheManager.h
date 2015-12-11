//
//  SCRequestCacheManager.h
//  syncano-ios
//
//  Created by Jan Lipmann on 07/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMacros.h"

@interface SCRequestCacheManager : NSObject

/**
 *  Initializes singleton
 */
SINGLETON_FOR_CLASS(SCRequestCacheManager);

- (void)enqueueGETRequestWithPath:(NSString *)path params:(NSDictionary *)params;
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params;
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params;
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params;
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params;
- (void)enqueueUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData;
@end
