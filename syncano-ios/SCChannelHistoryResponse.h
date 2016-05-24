//
//  SCChannelHistoryResponse.h
//  syncano-ios
//
//  Created by Jan Lipmann on 16/03/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCChannelNotificationMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCChannelHistoryResponse : NSObject
@property (nullable,nonatomic,copy) NSString *next;
@property (nullable,nonatomic,copy) NSString *prev;
@property (nullable,nonatomic,copy) NSArray<SCChannelNotificationMessage*> *objects;

- (instancetype)initWithJSONObject:(id)JSONObject;

@end
NS_ASSUME_NONNULL_END