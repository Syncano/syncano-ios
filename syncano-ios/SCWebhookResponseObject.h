//
//  SCWebhookResponseObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 28/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface SCWebhookResponseObject : NSObject
@property (nullable,nonatomic,copy) NSString *status; //TODO: use enum
@property (nullable,nonatomic,copy) NSNumber *duration;
@property (nullable,nonatomic,copy) id result;
@property (nullable,nonatomic,copy) NSDate *executedAt;

- (instancetype)initWithJSONObject:(id)JSONObject;
@end
NS_ASSUME_NONNULL_END