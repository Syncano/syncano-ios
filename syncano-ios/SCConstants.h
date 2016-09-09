//
//  SCConstants.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// API v1.0-1.1
@class SCTrace;
@class SCScriptEndpointResponse;
@class SCChannelNotificationMessage;
@class SCChannelHistoryResponse;
@class SCUser;
@class SCDevice;
@class SCBatchResponseItem;

// API v1.0-1.1
typedef void (^SCAPICompletionBlock)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error);
typedef void (^SCAPIFileDownloadCompletionBlock)(id _Nullable responseObject, NSError * _Nullable error);
typedef void (^SCDataObjectsCompletionBlock)(NSArray * _Nullable objects, NSError * _Nullable error);
typedef void (^SCParseObjectCompletionBlock)(id parsedObject, NSError * _Nullable error);
typedef void (^SCCompletionBlock)(NSError * _Nullable error);
typedef void (^SCCompletionBlockWithUser)(SCUser * _Nullable user, NSError * _Nullable error);
typedef void (^SCScriptCompletionBlock)(SCTrace * _Nullable trace,NSError * _Nullable error);
typedef void (^SCTraceCompletionBlock)(SCTrace * _Nullable trace, NSError * _Nullable error);
typedef void (^SCScriptEndpointCompletionBlock)(SCScriptEndpointResponse * _Nullable esponse, NSError * _Nullable error);
typedef void (^SCCustomResponseCompletionBlock)(id _Nullable responseObject, NSError * _Nullable error);
typedef void (^SCPleaseResolveQueryParametersCompletionBlock)(NSDictionary *queryParameters);
typedef void (^SCChannelPublishCompletionBlock)(SCChannelNotificationMessage * _Nullable notificationMessage, NSError * _Nullable error);
typedef void (^SCChannelHistoryCompletionBlock)(SCChannelHistoryResponse * _Nullable historyResponse, NSError * _Nullable error);
typedef void (^SCFileFetchCompletionBlock)(NSData * _Nullable data, NSError *_Nullable error);
typedef void (^SCFileFetchToDiskCompletionBlock)(NSURLResponse *response, NSURL *filePath, NSError * _Nullable error);
typedef void (^SCFileDownloadProgressCompletionBlock)(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);
typedef void (^SCPleaseEnumerateBlock)(BOOL *stop, NSArray *objects, NSError * _Nullable error);
typedef void (^SCFindRequestsCompletionBlock)(NSArray * _Nullable objects, NSError * _Nullable error);
typedef void (^SCDataObjectRevisionMismatchCompletionBlock)(BOOL mismatched, NSString * _Nullable description);
typedef void (^SCLocalStorageGenerateQueryStringCompletionBlock)(NSError * _Nullable error, NSString* query);
typedef void (^SCTemplateResponseCompletionBlock)(NSData* data, NSError * _Nullable error);
typedef void (^SCKeyManipulationCompletionBlock)(NSString *key, _Nullable id responseObject, NSError * _Nullable error);
typedef void (^SCDeviceObjectsCompletionBlock)(NSArray<SCDevice *>* _Nullable objects, NSError * _Nullable error);
typedef void (^SCBatchRequestCompletionBlock)(NSArray<SCBatchResponseItem *>* _Nullable items, NSError * _Nullable error);
typedef void (^SCScriptCompletionBlock)(SCTrace * _Nullable trace, NSError * _Nullable error);

extern NSString * const SCDataObjectErrorDomain;
extern NSString * const SCRequestErrorDomain;
extern NSString * const SCBatchErrorDomain;

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
extern NSString *const SCPleaseParameterOrderAscending;
extern NSString *const SCPleaseParameterIncludeCount;
extern NSString *const SCPleaseParameterCacheKey;

extern NSInteger const maxBatchRequestsCount;


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
    SCErrorCodeBatchNumberOfRequestsExceeded = 3
};

typedef NS_ENUM(NSUInteger, SCAPIVersion) {
    SCAPIVersion_1_0 = 1,
    SCAPIVersion_1_1 = 2
};

typedef NS_ENUM(NSUInteger, SCRequestMethod) {
    SCRequestMethodUndefined,
    SCRequestMethodGET,
    SCRequestMethodPOST,
    SCRequestMethodPATCH,
    SCRequestMethodDELETE,
    SCRequestMethodPUT
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
+ (SCRequestMethod)requestMethodFromString:(NSString *)methodString;
+ (NSString *)requestMethodToString:(SCRequestMethod)method;
+ (NSString *)versionStringForAPIVersion:(SCAPIVersion)apiVersion;
+ (NSURL *)baseURLForAPIVersion:(SCAPIVersion)apiVersion;
@end
NS_ASSUME_NONNULL_END