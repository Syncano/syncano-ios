//
//  SCPush.h
//  syncano-ios
//
//  Created by Jan Lipmann on 8/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

typedef NS_ENUM(NSUInteger, SCPushEnvironment) {
    SCPushEnvironmentDevelopment,
    SCPushEnvironmentProduction
};

@class Syncano,SCDevice;

NS_ASSUME_NONNULL_BEGIN


@interface SCPush : NSObject
@property (nonatomic,retain) NSArray<SCDevice*>* devices;
@property (nonatomic) SCPushEnvironment environment;

+ (SCPush *)pushWithEnvironment:(SCPushEnvironment)environment devices:(NSArray<SCDevice*>*)devices;

+ (SCPush *)pushWithEnvironment:(SCPushEnvironment)environment devices:(NSArray<SCDevice*>*)devices forSyncano:(Syncano *)syncano;

- (void)sendMessage:(NSString *)message completion:(SCCompletionBlock)completion;
@end

NS_ASSUME_NONNULL_END