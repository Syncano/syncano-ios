//
//  SCChannelNotificationMessage.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 08/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
NS_ASSUME_NONNULL_BEGIN
@interface SCChannelNotificationMessage : NSObject

@property (nullable,nonatomic,copy) NSNumber *identifier;
@property (nullable,nonatomic,copy) NSDate *createdAt;
@property (nullable,nonatomic,copy) NSDictionary *author;
@property (nonatomic) SCChannelNotificationMessageAction action;
@property (nullable,nonatomic,copy) NSDictionary *payload;
@property (nullable,nonatomic,copy) NSDictionary *metadata;

- (instancetype)initWithJSONObject:(id)JSONObject;
@end
NS_ASSUME_NONNULL_END