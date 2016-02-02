

#import "SCConstants.h"
#import "Mantle/Mantle.h"

NSString * const SCDataObjectErrorDomain = @"com.syncano.DataObjectErrorDomain";

NSString * const kBaseURL = @"https://api.syncano.io/v1/instances/";
NSString * const kUserKeyKeychainKey = @"com.syncano.kUserKeyKeychain";

NSString * const kSCPermissionTypeNone = @"none";
NSString * const kSCPermissionTypeRead = @"read";
NSString * const kSCPermissionTypeWrite = @"write";
NSString * const kSCPermissionTypeFull = @"full";
NSString * const kSCPermissionTypeSubscribe = @"subscribe";
NSString * const kSCPermissionTypePublish = @"publish";

NSString * const kSCChannelTypeDefault = @"default";
NSString * const kSCChannelTypeSeparateRooms = @"separate_rooms";

NSString * const kSCChannelNotificationMessageActionCreate = @"create";
NSString * const kSCChannelNotificationMessageActionUpdate = @"update";
NSString * const kSCChannelNotificationMessageActionDelete = @"delete";

NSString * const kSCSocialBackendFacebook = @"facebook";
NSString * const kSCSocialBackendGoogle = @"google-oauth2";
NSString * const kSCSocialBackendLinkedIn = @"linkedin";
NSString * const kSCSocialBackendTwitter = @"twitter";

@implementation SCConstants

+ (NSDateFormatter *)dateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *__dateFormatter = nil;
    dispatch_once(&onceToken, ^{
        __dateFormatter = [[NSDateFormatter alloc] init];
        __dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        __dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        __dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSX";
    });
    return __dateFormatter;
}

+ (SCDataObjectPermissionType)dataObjectPermissiontypeByString:(NSString *)typeString {
    if ([typeString isEqualToString:kSCPermissionTypeFull]) {
        return SCDataObjectPermissionTypeFull;
    }
    if ([typeString isEqualToString:kSCPermissionTypeRead]) {
        return SCDataObjectPermissionTypeRead;
    }
    if ([typeString isEqualToString:kSCPermissionTypeWrite]) {
        return SCDataObjectPermissionTypeWrite;
    }
    if ([typeString isEqualToString:kSCPermissionTypeNone]) {
        return SCDataObjectPermissionTypeNone;
    }
    return SCDataObjectPermissionTypeNotSet;
}

+ (SCChannelPermisionType)channelPermissionTypeByString:(NSString *)typeString {
    if ([typeString isEqualToString:kSCPermissionTypeSubscribe]) {
        return SCChannelPermisionTypeSubscribe;
    }
    if ([typeString isEqualToString:kSCPermissionTypePublish]) {
        return SCChannelPermisionTypePublish;
    }
    return SCChannelPermisionTypeNone;
}

+ (SCChannelType)channelTypeByString:(NSString *)typeString {
    return ([typeString isEqualToString:kSCChannelTypeDefault]) ? SCChannelTypeDefault : SCChannelTypeSeparateRooms;
}

+ (NSString *)socialAuthenticationBackendToString:(SCSocialAuthenticationBackend)backend {
    
    switch (backend) {
        case SCSocialAuthenticationBackendFacebook:
            return kSCSocialBackendFacebook;
        case SCSocialAuthenticationBackendGoogle:
            return kSCSocialBackendGoogle;
        case SCSocialAuthenticationBackendLinkedIn:
            return kSCSocialBackendLinkedIn;
        case SCSocialAuthenticationBackendTwitter:
            return kSCSocialBackendTwitter;
    }
    
}

+ (NSValueTransformer *)SCDataObjectPermissionsValueTransformer {
    NSDictionary *states = @{
                             kSCPermissionTypeNone : @(SCDataObjectPermissionTypeNone),
                             kSCPermissionTypeRead : @(SCDataObjectPermissionTypeRead),
                             kSCPermissionTypeWrite : @(SCDataObjectPermissionTypeWrite),
                             kSCPermissionTypeFull : @(SCDataObjectPermissionTypeFull)
                             };
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        if (value == nil) return @(SCDataObjectPermissionTypeNotSet);
        
        return states[value];
    } reverseBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return [states allKeysForObject:value].lastObject;
    }];
}

+ (NSValueTransformer *)SCDataObjectDatesTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [[self dateFormatter] dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [[self dateFormatter] stringFromDate:date];
    }];
}

+ (SCChannelNotificationMessageAction)channelNotificationMessageActionByString:(NSString *)actionString {
    if ([actionString isEqualToString:kSCChannelNotificationMessageActionCreate]) {
        return SCChannelNotificationMessageActionCreate;
    }
    if ([actionString isEqualToString:kSCChannelNotificationMessageActionUpdate]) {
        return SCChannelNotificationMessageActionUpdate;
    } if ([actionString isEqualToString:kSCChannelNotificationMessageActionDelete]) {
        return SCChannelNotificationMessageActionDelete;
    }
    return SCChannelNotificationMessageActionNone;
}
@end