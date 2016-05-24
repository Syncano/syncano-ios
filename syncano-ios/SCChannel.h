//
//  SCChannel.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 03/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "SCChannelDelegate.h"

@class Syncano;

NS_ASSUME_NONNULL_BEGIN

@interface SCChannel : NSObject

/**
 *  Channel name
 */
@property (nullable,nonatomic,retain) NSString *name;

/**
 *  Last message identifier
 */
@property (nullable,nonatomic,retain) NSNumber *lastId;

/**
 *  Room name
 */
@property (nullable,nonatomic,retain) NSString *room;

/**
 *  Channel delegate
 */
@property (nullable,nonatomic,assign) id<SCChannelDelegate> delegate;

/**
 *  Initializes channel
 *
 *  @param channelName channel name
 *
 *  @return SCChannel instance
 */
- (instancetype)initWithName:(NSString *)channelName;

/**
 *  Initializes channel
 *
 *  @param channelName channel name
 *  @param delegate    delegate object must conform to SCChannelDelegate protocol
 *
 *  @return SCChannel instance
 */
- (instancetype)initWithName:(NSString *)channelName andDelegate:(nullable id<SCChannelDelegate>)delegate;
/**
 *  Initializes channel
 *
 *  @param channelName channel name
 *  @param lastId      identifier of last fetched message
 *  @param delegate    delegate object must conform to SCChannelDelegate protocol
 *
 *  @return SCChannel instance
 */
- (instancetype)initWithName:(NSString *)channelName lastId:(NSNumber *)lastId andDelegate:(nullable id<SCChannelDelegate>)delegate;

/**
 *  Initializes channel
 *
 *  @param channelName channel name
 *  @param room        room name
 *  @param delegate    delegate object must conform to SCChannelDelegate protocol
 *
 *  @return SCChannel instance
 */
- (instancetype)initWithName:(NSString *)channelName room:(NSString *)room andDelegate:(nullable id<SCChannelDelegate>)delegate;

/**
 *  Initializes channel
 *
 *  @param channelName channel name
 *  @param lastId      identifier of last fetched message
 *  @param room        room name
 *  @param delegate    delegate object must conform to SCChannelDelegate protocol
 *
 *  @return SCChannel instance
 */
- (instancetype)initWithName:(NSString *)channelName lastId:(nullable NSNumber *)lastId room:(nullable NSString *)room andDelegate:(nullable id<SCChannelDelegate>)delegate;

/**
 *  Subscribes to channel using singletone Syncano instance
 */
- (void)subscribeToChannel;

/**
 *  Subscribes to channel using provided Syncano instance
 *
 *  @param syncano Syncano instance
 */
- (void)subscribeToChannelInSyncano:(Syncano *)syncano;

/**
 *  Publishes payload to channel using singleton Syncano instance
 *
 *  @param payload    NSDictionary payload
 *  @param completion completion block
 */
- (void)publishToChannelWithPayload:(NSDictionary *)payload completion:(nullable SCChannelPublishCompletionBlock)completion;

/**
 *  Publishes payload to channel using provided Syncano instance
 *
 *  @param syncano    Syncano instance
 *  @param payload    NSDictionary payload
 *  @param completion completion block
 */
- (void)publishToChannelInSyncano:(Syncano *)syncano withPayload:(NSDictionary *)payload completion:(nullable SCChannelPublishCompletionBlock)completion;

/**
 *  Gets channel history using singleton Syncano instance
 *
 *  @param completion completion blog
 */
- (void)getChannelHistoryWithCompletion:(SCChannelHistoryCompletionBlock)completion;

/**
 *  Gets channel history using provided Syncano instance
 *
 *  @param syncano    Syncano instance
 *  @param completion completion block
 */
- (void)getChannelHistoryFromSyncano:(Syncano *)syncano completion:(SCChannelHistoryCompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END