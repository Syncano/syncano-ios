//
//  SCPleaseForDevice.m
//  syncano-ios
//
//  Created by Jan Lipmann on 18/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPleaseForDevice.h"
#import "Syncano.h"
#import "SCAPIClient.h"
#import "SCParseManager+SCDevice.h"

@interface SCPleaseForDevice ()
@property (nonatomic,retain) SCAPIClient *apiClient;
@end

@implementation SCPleaseForDevice
+ (SCPleaseForDevice *)pleaseInstance {
  return [self pleaseInstanceWithAPIClient:[Syncano sharedAPIClient]];
}

+ (SCPleaseForDevice *)pleaseInstanceForSyncano:(Syncano *)syncano {
    return [self pleaseInstanceWithAPIClient:syncano.apiClient];
}

+ (SCPleaseForDevice *)pleaseInstanceWithAPIClient:(SCAPIClient *)apiClient {
    SCPleaseForDevice *please = [SCPleaseForDevice new];
    please.apiClient = apiClient;
    return please;
}

- (void)giveMeObjectsWithCompletion:(SCDeviceObjectsCompletionBlock)completion {
    [self getDeviceObjectsFromAPIWithParameters:nil completion:completion];
}

- (void)giveMeObjectsWithParameters:(NSDictionary *)parameters completion:(SCDeviceObjectsCompletionBlock)completion {
    [self getDeviceObjectsFromAPIWithParameters:parameters completion:completion];
}

- (void)getDeviceObjectsFromAPIWithParameters:(NSDictionary *)parameters completion:(SCDeviceObjectsCompletionBlock)completion {
    [self.apiClient GETWithPath:@"push_notifications/apns/devices/" params:parameters completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completion == nil) {
            return;
        }
        if (error != nil) {
            completion(nil,error);
            return;
        }
        NSError *parseError = nil;
        NSArray<SCDevice*>* devices = [[SCParseManager sharedSCParseManager] parsedDevicesFromJSONObject:responseObject error:&parseError];
        completion(devices,parseError);
    }];
}


@end
