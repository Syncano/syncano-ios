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
static NSString * const kDeviceUserId = @"user";
static NSString * const kDeviceDeviceId = @"device_id";
static NSString * const kDeviceMetadata = @"metadata";
static NSString * const kDeviceIsActive = @"is_active";

@implementation SCDevice {

}

+ (SCDevice *)deviceWithTokenFromData:(NSData *)tokenData {
    return [[SCDevice alloc] initWithTokenFromData:tokenData];
}

- (instancetype)initWithTokenFromData:(NSData *)tokenData {
    self = [super init];
    if(self) {
        self.registrationId = [[self class] convertDeviceTokenToString:tokenData];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"label" : kDeviceLabel,
             @"userId" : kDeviceUserId,
             @"deviceId" : kDeviceDeviceId,
             @"registrationId" : kDeviceRegistrationId,
             @"metadata" : kDeviceMetadata,
             @"isActive" : kDeviceIsActive};
}


- (NSString *)deviceToken {
    return _registrationId;
}

- (NSString *)path {
    return [NSString stringWithFormat:@"push_notifications/apns/devices/%@",self.registrationId];
}

- (void)setMetadataObject:(id)object forKey:(nonnull NSString *)key {
    if (!self.metadata) {
        self.metadata = [NSDictionary new];
    }
    NSMutableDictionary *mutableMetadata = [self.metadata mutableCopy];
    [mutableMetadata setObject:object forKey:key];
    self.metadata = [mutableMetadata copy];
}

- (void)saveWithCompletionBlock:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)saveToSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)deleteWithCompletion:(SCCompletionBlock)completion {
    [self deleteUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)deleteFromSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self deleteUsingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)deleteUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    [apiClient DELETEWithPath:[self path] params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (NSDictionary *)paramsWithError:(NSError **)error  {
    return [MTLJSONAdapter JSONDictionaryFromModel:self error:error];
}

- (void)saveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    NSString *path = @"push_notifications/apns/devices/";
    NSError *paramsParseError = nil;
    NSDictionary *params = [self paramsWithError:&paramsParseError];
    if (paramsParseError != nil) {
        if (completion) {
            completion(paramsParseError);
        }
        return;
    }
    [apiClient postTaskWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
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
