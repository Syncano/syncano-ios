//
//  SCPleaseForPush.m
//  syncano-ios
//
//  Created by Jan Lipmann on 8/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPleaseForPush.h"
#import "Syncano.h"
#import "SCAPIClient.h"
#import "SCMacros.h"


@implementation SCPleaseForPush
+ (SCPleaseForPush *)pleaseForSyncano:(Syncano *)syncano environment:(SCPushPleaseEnvironment)environment devices:(NSArray<SCDevice*>*)devices; {
    SCPleaseForPush *please = [SCPleaseForPush new];
    please.syncano = syncano;
    please.environment = environment;
    please.devices = devices;
    return please;
}

- (NSDictionary *)resolvedParamsForRequestWithMessage:(NSString *)message {
    NSMutableDictionary *content = [NSMutableDictionary new];
    
    content[@"environment"] = [self environmentStringRepresentation];
    if (message != nil) {
        content[@"aps"] = @{@"alert" : message};
    }
    content[@"registration_ids"] = [self.devices valueForKeyPath:@"deviceId"];
    
    return @{@"content" : content};
}

- (NSString *)environmentStringRepresentation {
    return self.environment == SCPushPleaseEnvironmentDevelopment ? @"development" : @"production";
}

- (void)sendMessage:(NSString *)message completion:(SCCompletionBlock)completion {
    SCParameterAssert(self.syncano != nil, @"You should provide syncano object");
    SCParameterAssert(self.devices != nil, @"You should provide at least one device object");
    NSString *path = @"push_notifications/apns/messages/";
    NSDictionary *params = [self resolvedParamsForRequestWithMessage:message];
    [self.syncano.apiClient POSTWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}
@end
