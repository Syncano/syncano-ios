//
//  SCDevice.h
//  syncano-ios
//
//  Created by Jan Lipmann on 25/02/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class Syncano;

@interface SCDevice : NSObject
@property (nonatomic,readonly) NSString *deviceToken;
@property (nonatomic,readonly) NSString *label;

+ (SCDevice *)deviceWithTokenFromData:(NSData *)tokenData label:(NSString *)label;
- (instancetype)initWithTokenFromData:(NSData *)tokenData label:(NSString *)label;

/**
 *  Saves object to API in background for singleton default Syncano instance
 *
 *  @param completion completion block
 *
 */
- (void)saveWithCompletionBlock:(SCCompletionBlock)completion;

/**
 *  Saves object to API in background for chosen Syncano instance
 *
 *  @param syncano    Saves object to API in background for provided Syncano instance
 *  @param completion completion block
 *
 */
- (void)saveToSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion;

@end
