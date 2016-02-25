//
//  SCDevice.m
//  syncano-ios
//
//  Created by Jan Lipmann on 25/02/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDevice.h"
#import "Syncano.h"

@implementation SCDevice {
    NSString *_deviceToken;
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

- (void)saveWithCompletionBlock:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)saveToSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)saveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    NSString *path = @"/push_notifications/apns/devices/";
    NSDictionary *params = @{@"registration_id" : self.deviceToken};
    [apiClient POSTWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
