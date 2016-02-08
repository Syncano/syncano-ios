//
//  MessageVIew.m
//  syncano-ios
//
//  Created by Jakub Machoń on 25.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "MessageView.h"

@implementation MessageView

+ (NSString*)classNameForAPI {
    return @"message";
}

+ (NSString*)viewNameForAPI {
    return @"messages_last_week";
}

@end
