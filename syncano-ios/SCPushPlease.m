//
//  SCPushPlease.m
//  syncano-ios
//
//  Created by Jan Lipmann on 8/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPushPlease.h"
#import "Syncano.h"
#import "SCAPIClient.h"
#import "SCMacros.h"


@implementation SCPushPlease
+ (SCPushPlease *)pleaseForSyncano:(Syncano *)syncano environment:(SCPushPleaseEnvironment)environment device:(SCDevice *)device {
    SCPushPlease *please = [SCPushPlease new];
    please.syncano = syncano;
    please.environment = environment;
    please.device = device;
    return please;
}

- (NSDictionary *)resolvedParamsForRequestWithMessage:(NSString *)message {
    //'{"content": {"environment": "development","aps": {"alert": "hello"}}'
    return @{@"content" : @{@"environment" : [self environmentStringRepresentation] , @"aps" : @{@"alert" : message}}};
}

- (NSString *)environmentStringRepresentation {
    return self.environment == SCPushPleaseEnvironmentDevelopment ? @"development" : @"production";
}

- (void)sendMessage:(NSString *)message completion:(SCCompletionBlock)completion {
    SCParameterAssert(self.syncano != nil, @"You should provide syncano object");
    SCParameterAssert(self.device != nil, @"You should provide device object");
    NSString *path = [NSString stringWithFormat:@"push_notifications/apns/devices/%@/send_message/",self.device.deviceId];
    NSDictionary *params = [self resolvedParamsForRequestWithMessage:message];
    [self.syncano.apiClient POSTWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}
@end
