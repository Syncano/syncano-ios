//
//  SCPleaseForDevice.h
//  syncano-ios
//
//  Created by Jan Lipmann on 18/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

typedef NS_ENUM(NSUInteger, SCPleaseForDeviceParameter) {
    SCPleaseForDeviceParameterUser,
    SCPleaseForDeviceParameterDeviceId,
};

NS_ASSUME_NONNULL_BEGIN

@class Syncano;

@interface SCPleaseForDevice : NSObject
+ (SCPleaseForDevice *)pleaseInstance;
+ (SCPleaseForDevice *)pleaseInstanceForSyncano:(Syncano *)syncano;

/**
 *  Creates and runs a simple request without any query parameters or statements
 *
 *  @param completion completion block
 */
- (void)giveMeObjectsWithCompletion:(SCDeviceObjectsCompletionBlock)completion;

/**
 *  Creates and runs an API request for oan bject with a query parameters
 *
 *  @param parameters NSDictionary with query params
 *  @param completion completion block
 */
- (void)giveMeObjectsWithParameters:(NSDictionary *)parameters completion:(SCDeviceObjectsCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END