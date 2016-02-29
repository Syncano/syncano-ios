//
//  SCDevice.h
//  syncano-ios
//
//  Created by Jan Lipmann on 25/02/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "Mantle.h"

@class Syncano;

@interface SCDevice : MTLModel
@property (nonatomic,readonly) NSString * deviceToken;
@property (nonatomic,retain) NSString *label;
@property (nonatomic,retain) NSNumber *userId;
@property (nonatomic,retain) NSString *deviceId;


+ (SCDevice *)deviceWithTokenFromData:(NSData *)tokenData;

- (instancetype)initWithTokenFromData:(NSData *)tokenData;

- (void)setMetadataObject:(id)object forKey:(nonnull NSString *)key;

/**
 *  Saves object to API in background for singleton default Syncano instance
 *
 *  @param completion completion block
 *
 */
- (void)saveWithCompletionBlock:(_Nullable SCCompletionBlock)completion;

/**
 *  Saves object to API in background for chosen Syncano instance
 *
 *  @param syncano    Saves object to API in background for provided Syncano instance
 *  @param completion completion block
 *
 */
- (void)saveToSyncano:(Syncano *)syncano withCompletion:(_Nullable SCCompletionBlock)completion;

@end