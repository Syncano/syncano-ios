//
//  SCRequestCacheManager.h
//  syncano-ios
//
//  Created by Jan Lipmann on 07/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCRequest;

@interface SCRequestCacheManager : NSObject
- (void)enqueueRequest:(SCRequest *)request;
@end
