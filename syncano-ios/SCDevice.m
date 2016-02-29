//
//  SCDevice.m
//  syncano-ios
//
//  Created by Jan Lipmann on 25/02/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDevice.h"
#import "Syncano.h"

static NSString * const kDeviceRegistrationId = @"registration_id";
static NSString * const kDeviceLabel = @"label";
static NSString * const kDeviceUserId = @"user_id";
static NSString * const kDeviceDeviceId = @"device_id";
static NSString * const kDeviceMetadata = @"metadata";

@implementation SCDevice {
    NSString *_deviceToken;
    NSMutableDictionary *_metadata;
}

+ (SCDevice *)deviceWithTokenFromData:(NSData *)tokenData {
    return [[SCDevice alloc] initWithTokenFromData:tokenData];
}

- (instancetype)initWithTokenFromData:(NSData *)tokenData {
    self = [super init];
    if(self) {
        _deviceToken = [[self class] convertDeviceTokenToString:tokenData];
    }
    return self;
}

- (NSString *)deviceToken {
    return _deviceToken;
}

- (NSMutableDictionary *)metadata {
    if (!_metadata) {
        _metadata = [NSMutableDictionary new];
    }
    return _metadata;
}

- (void)setMetadataObject:(id)object forKey:(nonnull NSString *)key {
    [_metadata setObject:object forKey:key];
}

- (void)saveWithCompletionBlock:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)saveToSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:syncano.apiClient withCompletion:completion];
}

- (NSDictionary *)params {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.deviceToken.length > 0) {
        params[kDeviceRegistrationId] = self.deviceToken;
    }
    if (self.deviceId.length > 0) {
        params[kDeviceDeviceId] = self.deviceId;
    }
    if (_metadata) {
        params[kDeviceMetadata] = _metadata;
    }
    if (self.label.length > 0) {
        params[kDeviceLabel] = self.label;
    }
    /* Below is temporary workaround while label is required field */
    else {
        params[kDeviceLabel] = @"tempLabel";
    }
    if (self.userId) {
        params[kDeviceUserId] = self.userId;
    }
    return [NSDictionary dictionaryWithDictionary:params];
}

- (void)saveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    NSString *path = @"push_notifications/apns/devices/";
    [apiClient postTaskWithPath:path params:[self params] completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (NSString *)convertDeviceTokenToString:(NSData *)deviceTokenData {
    NSMutableString *hexString = [NSMutableString string];
    const unsigned char *bytes = [deviceTokenData bytes];
    for (int i = 0; i < [deviceTokenData length]; i++) {
        [hexString appendFormat:@"%02x", bytes[i]];
    }
    return [NSString stringWithString:hexString];
}
@end
