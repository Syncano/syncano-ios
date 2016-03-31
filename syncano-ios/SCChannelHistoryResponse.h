//
//  SCChannelHistoryResponse.h
//  syncano-ios
//
//  Created by Jan Lipmann on 16/03/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCChannelNotificationMessage.h"

@interface SCChannelHistoryResponse : UIControl
@property (nonatomic,copy) NSString *next;
@property (nonatomic,copy) NSString *prev;
@property (nonatomic,copy) NSArray<SCChannelNotificationMessage*> *objects;

- (instancetype)initWithJSONObject:(id)JSONObject;

@end
