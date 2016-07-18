//
//  SCDevice.h
//  syncano-ios
//
//  Created by Jan Lipmann on 25/02/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "Mantle/Mantle.h"

@class Syncano;

NS_ASSUME_NONNULL_BEGIN

@interface SCDevice : MTLModel <MTLJSONSerializing>
@property (nullable,nonatomic,readonly) NSString * deviceToken;
@property (nullable,nonatomic,retain) NSString *label;
@property (nullable,nonatomic,retain) NSNumber *userId;
@property (nullable,nonatomic,retain) NSString *deviceId;
@property (nullable,nonatomic,retain) NSString *registrationId;
@property (nullable,nonatomic,retain) NSDictionary *metadata;
@property (nonatomic) BOOL isActive;



/**
 *  Creates SCDevice instance with provided token data
 *
 *  @param tokenData NSData token from APNS
 *
 *  @return SCDevice instance
 */
+ (SCDevice *)deviceWithTokenFromData:(NSData *)tokenData;

/**
 *  Initializes SCDevice instance with provided token data
 *
 *  @param tokenData NSData token from APNS
 *
 *  @return SCDevice instance
 */
- (instancetype)initWithTokenFromData:(NSData *)tokenData;

/**
 *  Sets metadata object for porvided key
 *
 *  @param object metadata object
 *  @param key    key
 */
- (void)setMetadataObject:(id)object forKey:(NSString *)key;

/**
 *  Saves object to API in background for singleton default Syncano instance
 *
 *  @param completion completion block
 *
 */
- (void)saveWithCompletionBlock:(nullable SCCompletionBlock)completion;

/**
 *  Saves object to API in background for chosen Syncano instance
 *
 *  @param syncano    Saves object to API in background for provided Syncano instance
 *  @param completion completion block
 *
 */
- (void)saveToSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Deletes device from API using singleton Syncano instance
 *
 *  @param completion completion block
 */
- (void)deleteWithCompletion:(SCCompletionBlock)completion;

/**
 *  Deletes device from API using provided Syncano instance
 *
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
- (void)deleteFromSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END