//
//  SCScriptEndpointResponse.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/8/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCScriptEndpointResponse : NSObject

@property (nonatomic,copy) NSString *status; //TODO: use enum
@property (nonatomic,copy) NSNumber *duration;
@property (nonatomic,copy) id result;
@property (nonatomic,copy) NSDate *executedAt;

- (instancetype)initWithJSONObject:(id)JSONObject;

@end
