//
//  SCPush.m
//  syncano-ios
//
//  Created by Jan Lipmann on 8/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPush.h"
#import "Syncano.h"
#import "SCAPIClient.h"
#import "SCMacros.h"

@interface SCPush ()
@property (nonatomic,retain) SCAPIClient *apiClient;
@end


@implementation SCPush

+ (SCPush *)pushWithEnvironment:(SCPushEnvironment)environment devices:(NSArray<SCDevice*>*)devices {
    return [self pushWithEnvironment:environment devices:devices apiClient:[Syncano sharedAPIClient]];
}

+ (SCPush *)pushWithEnvironment:(SCPushEnvironment)environment devices:(NSArray<SCDevice*>*)devices forSyncano:(Syncano *)syncano {
    return  [self pushWithEnvironment:environment devices:devices apiClient:syncano.apiClient];
}

+ (SCPush *)pushWithEnvironment:(SCPushEnvironment)environment devices:(NSArray<SCDevice *> *)devices apiClient:(SCAPIClient *)apiClient {
    SCPush *push = [SCPush new];
    push.apiClient = apiClient;
    push.environment = environment;
    push.devices = devices;
    return push;
}

- (NSDictionary *)resolvedParamsForRequestWithMessage:(NSString *)message {
    NSMutableDictionary *content = [NSMutableDictionary new];
    
    content[@"environment"] = [self environmentStringRepresentation];
    if (message != nil) {
        content[@"aps"] = @{@"alert" : message};
    }
    content[@"registration_ids"] = [self.devices valueForKeyPath:@"registrationId"];
    
    return @{@"content" : content};
}

- (NSString *)environmentStringRepresentation {
    return self.environment == SCPushEnvironmentDevelopment ? @"development" : @"production";
}

- (void)sendMessage:(NSString *)message completion:(SCCompletionBlock)completion {
    SCParameterAssert(self.apiClient != nil, @"You should provide syncano object");
    SCParameterAssert(self.devices != nil, @"You should provide at least one device object");
    NSString *path = @"push_notifications/apns/messages/";
    NSDictionary *params = [self resolvedParamsForRequestWithMessage:message];
    [self.apiClient POSTWithPath:path params:params completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}
@end
