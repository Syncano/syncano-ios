

#import "SCConstants.h"
#import "Mantle/Mantle.h"

NSString * const SCDataObjectErrorDomain = @"com.syncano.DataObjectErrorDomain";

NSString * const kBaseURLFormatString = @"https://api.syncano.io/%@/instances/";
NSString * const kUserKeyKeychainKey = @"com.syncano.kUserKeyKeychain";

NSString * const kSCPermissionTypeNone = @"none";
NSString * const kSCPermissionTypeRead = @"read";
NSString * const kSCPermissionTypeWrite = @"write";
NSString * const kSCPermissionTypeFull = @"full";
NSString * const kSCPermissionTypeSubscribe = @"subscribe";
NSString * const kSCPermissionTypePublish = @"publish";

NSString * const kSCChannelTypeDefault = @"default";
NSString * const kSCChannelTypeSeparateRooms = @"separate_rooms";

NSString * const kExpectedRevisionRequestParam = @"expected_revision";
NSString * const kRevisionMismatchResponseError = @"expected_revision";

NSString * const kSCChannelNotificationMessageActionCreate = @"create";
NSString * const kSCChannelNotificationMessageActionUpdate = @"update";
NSString * const kSCChannelNotificationMessageActionDelete = @"delete";

NSString * const kSCSocialBackendFacebook = @"facebook";
NSString * const kSCSocialBackendGoogle = @"google-oauth2";
NSString * const kSCSocialBackendLinkedIn = @"linkedin";
NSString * const kSCSocialBackendTwitter = @"twitter";

NSString * const kDatabaseName = @"SyncanoDataObjects";

NSString * const kSyncanoResponseErrorKey = @"com.Syncano.response.error";

NSString * const kSCCertificateFileName = @"certfile.der";

NSString *const kSCDataObjectPropertyTypeKey = @"type";
NSString *const kSCDataObjectPropertyTypeValue = @"value";
NSString *const kSCDataObjectPropertyTypeDateTime = @"datetime";

NSString *const SCPleaseParameterFields = @"fields";
NSString *const SCPleaseParameterExcludedFields = @"excluded_fields";
NSString *const SCPleaseParameterPageSize = @"page_size";
NSString *const SCPleaseParameterOrderBy = @"order_by";
NSString *const SCPleaseParameterIncludeCount = @"include_count";

SCAPIVersion const kDefaultAPIVersion = SCAPIVersion_1_0;

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

/**
 * Syncano datetime object can be either a string - for created_at and updated_at
 * or a dictionary - for user define datetime properties
 */
+ (NSString *)dateStringFromSyncanoDate:(id)syncanoDate {
    NSString *dateString = nil;
    if ([syncanoDate isKindOfClass:[NSDictionary class]] &&
        [[syncanoDate objectForKey:kSCDataObjectPropertyTypeKey] isEqualToString:kSCDataObjectPropertyTypeDateTime] &&
        [syncanoDate objectForKey:kSCDataObjectPropertyTypeValue]) {
        dateString = [syncanoDate objectForKey:kSCDataObjectPropertyTypeValue];
    } else if ([syncanoDate isKindOfClass:[NSString class]]) {
        dateString = syncanoDate;
    }
    return dateString;
}

+ (NSValueTransformer *)SCDataObjectDatesTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id date, BOOL *success, NSError *__autoreleasing *error) {
        NSString *dateString = [self dateStringFromSyncanoDate:date];
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

+ (NSString *)versionStringForAPIVersion:(SCAPIVersion)apiVersion {
    NSString *versionString = nil;
    switch (apiVersion) {
        case SCAPIVersion_1_0:
            versionString = @"v1";
            break;
        case SCAPIVersion_1_1:
            versionString = @"v1.1";
            break;
    }
    return versionString;
}

+ (NSURL *)baseURLForAPIVersion:(SCAPIVersion)apiVersion {
    NSString *stringURL = [NSString stringWithFormat:kBaseURLFormatString,[self versionStringForAPIVersion:apiVersion]];
    NSURL *baseURL = [NSURL URLWithString:stringURL];
    return baseURL;
}
@end