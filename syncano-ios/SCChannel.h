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

@interface SCChannel : NSObject

/**
 *  Channel name
 */
@property (nonatomic,retain) NSString *name;

/**
 *  Last message identifier
 */
@property (nonatomic,retain) NSNumber *lastId;

/**
 *  Room name
 */
@property (nonatomic,retain) NSString *room;

/**
 *  Channel delegate
 */
@property (nonatomic,assign) id<SCChannelDelegate> delegate;

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
- (instancetype)initWithName:(NSString *)channelName andDelegate:(id<SCChannelDelegate>)delegate;
/**
 *  Initializes channel
 *
 *  @param channelName channel name
 *  @param lastId      identifier of last fetched message
 *  @param delegate    delegate object must conform to SCChannelDelegate protocol
 *
 *  @return SCChannel instance
 */
- (instancetype)initWithName:(NSString *)channelName lastId:(NSNumber *)lastId andDelegate:(id<SCChannelDelegate>)delegate;

/**
 *  Initializes channel
 *
 *  @param channelName channel name
 *  @param room        room name
 *  @param delegate    delegate object must conform to SCChannelDelegate protocol
 *
 *  @return SCChannel instance
 */
- (instancetype)initWithName:(NSString *)channelName room:(NSString *)room andDelegate:(id<SCChannelDelegate>)delegate;

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
- (instancetype)initWithName:(NSString *)channelName lastId:(NSNumber *)lastId room:(NSString *)room andDelegate:(id<SCChannelDelegate>)delegate;

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
- (void)publishToChannelWithPayload:(NSDictionary *)payload completion:(SCChannelPublishCompletionBlock)completion;

/**
 *  Publishes payload to channel using provided Syncano instance
 *
 *  @param syncano    Syncano instance
 *  @param payload    NSDictionary payload
 *  @param completion completion block
 */
- (void)publishToChannelInSyncano:(Syncano *)syncano withPayload:(NSDictionary *)payload completion:(SCChannelPublishCompletionBlock)completion;

@end
