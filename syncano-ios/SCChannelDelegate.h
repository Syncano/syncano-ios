//
//  SCPollCallbackProtocol.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 08/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCChannelNotificationMessage.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SCChannelDelegate <NSObject>
- (void)channelDidReceiveNotificationMessage:(SCChannelNotificationMessage *)notificationMessage;
@end
NS_ASSUME_NONNULL_END
