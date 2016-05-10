//
//  SCConstants.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//
#import <Foundation/Foundation.h>

// API v1.0-1.1
@class SCTrace;
@class SCScriptEndpointResponse;
@class SCChannelNotificationMessage;
@class SCChannelHistoryResponse;
@class SCUser;

// API v1.0
@class SCWebhookResponseObject;

// API v1.0-1.1
typedef void (^SCAPICompletionBlock)(NSURLSessionDataTask *task, id responseObject, NSError *error);
typedef void (^SCAPIFileDownloadCompletionBlock)(id responseObject, NSError *error);
typedef void (^SCDataObjectsCompletionBlock)(NSArray *objects, NSError *error);
typedef void (^SCParseObjectCompletionBlock)(id parsedObject, NSError *error);
typedef void (^SCCompletionBlock)(NSError *error);
typedef void (^SCCompletionBlockWithUser)(SCUser *user, NSError *error);
typedef void (^SCScriptCompletionBlock)(SCTrace *trace,NSError *error);
typedef void (^SCTraceCompletionBlock)(SCTrace *trace, NSError *error);
typedef void (^SCScriptEndpointCompletionBlock)(SCScriptEndpointResponse *response, NSError *error);
typedef void (^SCCustomResponseCompletionBlock)(id responseObject, NSError *error);
typedef void (^SCPleaseResolveQueryParametersCompletionBlock)(NSDictionary *queryParameters);
typedef void (^SCChannelPublishCompletionBlock)(SCChannelNotificationMessage *notificationMessage, NSError *error);
typedef void (^SCChannelHistoryCompletionBlock)(SCChannelHistoryResponse *historyResponse, NSError *error);
typedef void (^SCFileFetchCompletionBlock)(NSData *data, NSError *error);
typedef void (^SCFileFetchToDiskCompletionBlock)(NSURLResponse *response, NSURL *filePath, NSError *error);
typedef void (^SCFileDownloadProgressCompletionBlock)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void (^SCPleaseEnumerateBlock)(BOOL *stop, NSArray *objects, NSError *error);
typedef void (^SCFindRequestsCompletionBlock)(NSArray *objects, NSError *error);
typedef void (^SCDataObjectRevisionMismatchCompletionBlock)(BOOL mismatched, NSString *description);
typedef void (^SCLocalStorageGenerateQueryStringCompletionBlock)(NSError *error, NSString* query);

// API v1.0
typedef void (^SCCodeBoxCompletionBlock)(SCTrace *trace,NSError *error);
typedef void (^SCWebhookCompletionBlock)(SCWebhookResponseObject *responseObject, NSError *error);


extern NSString * const SCDataObjectErrorDomain;

extern NSString * const kBaseURLFormatString;
extern NSString * const kUserKeyKeychainKey;

extern NSString * const kSCPermissionTypeNone;
extern NSString * const kSCPermissionTypeRead;
extern NSString * const kSCPermissionTypeWrite;
extern NSString * const kSCPermissionTypeFull;
extern NSString * const kSCPermissionTypeSubscribe;
extern NSString * const kSCPermissionTypePublish;

extern NSString * const kSCChannelTypeDefault;
extern NSString * const kSCChannelTypeSeparateRooms;

extern NSString * const kSCSocialBackendFacebook;
extern NSString * const kSCSocialBackendGoogle;

extern NSString * const kSCChannelNotificationMessageActionCreate;
extern NSString * const kSCChannelNotificationMessageActionUpdate;
extern NSString * const kSCChannelNotificationMessageActionDelete;

extern NSString * const kSyncanoResponseErrorKey;

extern NSString * const kSCCertificateFileName;

extern NSString * const kExpectedRevisionRequestParam;
extern NSString * const kRevisionMismatchResponseError;
extern NSString * const kDatabaseName;

extern NSString *const kSCDataObjectPropertyTypeKey;
extern NSString *const kSCDataObjectPropertyTypeValue;
extern NSString *const kSCDataObjectPropertyTypeDateTime;

extern NSString *const SCPleaseParameterFields;
extern NSString *const SCPleaseParameterExcludedFields;
extern NSString *const SCPleaseParameterPageSize;
extern NSString *const SCPleaseParameterOrderBy;
extern NSString *const SCPleaseParameterIncludeCount;
extern NSString *const SCPleaseParameterTemplateResponse;

typedef NS_ENUM(NSUInteger, SCDataObjectPermissionType) {
    SCDataObjectPermissionTypeNone,
    SCDataObjectPermissionTypeRead,
    SCDataObjectPermissionTypeWrite,
    SCDataObjectPermissionTypeFull,
    SCDataObjectPermissionTypeNotSet
};

typedef NS_ENUM(NSUInteger, SCChannelPermisionType) {
    SCChannelPermisionTypeNone,
    SCChannelPermisionTypeSubscribe,
    SCChannelPermisionTypePublish,
};

typedef NS_ENUM(NSUInteger, SCChannelType) {
    SCChannelTypeDefault,
    SCChannelTypeSeparateRooms
};

typedef NS_ENUM(NSUInteger, SCSocialAuthenticationBackend) {
    SCSocialAuthenticationBackendFacebook,
    SCSocialAuthenticationBackendGoogle,
    SCSocialAuthenticationBackendLinkedIn,
    SCSocialAuthenticationBackendTwitter,
};

typedef NS_ENUM(NSUInteger, SCChannelNotificationMessageAction) {
    SCChannelNotificationMessageActionNone,
    SCChannelNotificationMessageActionCreate,
    SCChannelNotificationMessageActionUpdate,
    SCChannelNotificationMessageActionDelete,
};

typedef NS_ENUM(NSUInteger, SCErrorCode) {
    SCErrorCodeDataObjectWrongParentClass = 1,
    SCErrorCodeDataObjectNonExistingPropertyName = 2,
};

typedef NS_ENUM(NSUInteger, SCAPIVersion) {
    SCAPIVersion_1_0 = 1,
    SCAPIVersion_1_1 = 2
};

extern SCAPIVersion const kDefaultAPIVersion;

@interface SCConstants : NSObject
+ (SCDataObjectPermissionType)dataObjectPermissiontypeByString:(NSString *)typeString;
+ (SCChannelPermisionType)channelPermissionTypeByString:(NSString *)typeString;
+ (SCChannelType)channelTypeByString:(NSString *)typeString;
+ (NSString *)socialAuthenticationBackendToString:(SCSocialAuthenticationBackend)backend;
+ (NSValueTransformer *)SCDataObjectPermissionsValueTransformer;
+ (NSValueTransformer *)SCDataObjectDatesTransformer;
+ (SCChannelNotificationMessageAction)channelNotificationMessageActionByString:(NSString *)actionString;
+ (NSURL *)baseURLForAPIVersion:(SCAPIVersion)apiVersion;
@end