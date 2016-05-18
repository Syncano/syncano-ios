//
//  SCScriptEndpointResponse.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/8/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCScriptEndpointResponse : NSObject

@property (nullable,nonatomic,copy) NSString *status; //TODO: use enum
@property (nullable,nonatomic,copy) NSNumber *duration;
@property (nullable,nonatomic,copy) id result;
@property (nullable,nonatomic,copy) NSDate *executedAt;

- (instancetype)initWithJSONObject:(id)JSONObject;

@end
NS_ASSUME_NONNULL_END