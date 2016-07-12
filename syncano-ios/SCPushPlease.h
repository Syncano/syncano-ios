//
//  SCPushPlease.h
//  syncano-ios
//
//  Created by Jan Lipmann on 8/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

typedef NS_ENUM(NSUInteger, SCPushPleaseEnvironment) {
    SCPushPleaseEnvironmentDevelopment,
    SCPushPleaseEnvironmentProduction
};

@class Syncano,SCDevice;

@interface SCPushPlease : NSObject
@property (nonatomic,retain) Syncano *syncano;
@property (nonatomic,retain) NSArray<SCDevice*>* devices;
@property (nonatomic) SCPushPleaseEnvironment environment;

+ (SCPushPlease *)pleaseForSyncano:(Syncano *)syncano environment:(SCPushPleaseEnvironment)environment;

- (void)sendMessage:(NSString *)message completion:(SCCompletionBlock)completion;
@end
