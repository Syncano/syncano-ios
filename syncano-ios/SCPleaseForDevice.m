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
@end
