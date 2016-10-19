//
//  Syncano.h
//  syncano-ios
//
//  Created by Jan Lipmann on 26/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCMacros.h"
#import "SCConstants.h"
#import "SCPlease.h"
#import "SCPlease+LocalStorage.h"
#import "SCPleaseForTemplate.h"
#import "SCDataObject.h"
#import "SCDataObject+LocalStorage.h"
#import "SCDataObject+ArrayOperators.h"
#import "SCPredicate.h"
#import "SCCompoundPredicate.h"
#import "SCParseManager.h"
#import "SCParseManager+SCDataObject.h"
#import "SCParseManager+SCUser.h"
#import "SCAPIClient.h"
#import "SCUser.h" 
#import "SCChannel.h"
#import "SCFile.h"
#import "SCDevice.h"
#import "SCPleaseForDevice.h"
#import "SCPush.h"
#import "SCRegisterManager.h"
#import "SCGeoPoint.h"
#import "SCRelation.h"
#import "SCDataObject+RelationOperators.h"
#import "SCBatch.h"
#import "SCBatchResponseItem.h"

@class SCAPIClient,SCLocalStore;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Main Syncano Class
 */
@interface Syncano : NSObject
/**
 *  API Key
 */
@property (nullable, nonatomic,copy) NSString *apiKey;
/**
 *  Syncano Instance name
 */
@property (nullable, nonatomic,copy) NSString *instanceName;
/**
 *  Session CLient to comunicate with API
 */
@property (nullable, nonatomic,retain) SCAPIClient *apiClient;


+ (nullable SCLocalStore *)localStore;

/**
 *  Initiates Singleton instance of Syncano Class
 *
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *
 *  @return Syncano singleton instance
 */
+ (Syncano *)sharedInstanceWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName;


/**
 *  Initiates Singleton instance of Syncano Class
 *
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *  @param completion       completion block
 *
 *  @return Syncano singleton instance
 */
+ (Syncano *)sharedInstanceWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Returns API Key from Syncano singleton instance
 *
 *  @return API Key string
 */
+ (nullable NSString *)getApiKey;
/**
 *  Returns API instance name form Syncano singleton instance
 *
 *  @return instance name string
 */
+ (nullable NSString *)getInstanceName;
/**
 *  Returns API client from Syncano singleton instance
 *
 *  @return SCAPIClient object
 */
+ (SCAPIClient *)sharedAPIClient;




/**
 *  Initiates instance of Syncano Class
 *
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *
 *  @return Syncano instance
 */
- (instancetype)initWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName;


/**
 *  Initiates instance of Syncano Class and validates it with API
 *
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *  @param completion       completion block
 *
 *  @return Syncano instance
 */
- (instancetype)initWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Initiates and returns instance of Syncano Class
 *
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *
 *  @return Syncano instance
 */
+ (Syncano *)newSyncanoWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName;


/**
 *  Initiates and returns instance of Syncano Class
 *
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *  @param completion       completion block
 *
 *  @return Syncano instance
 */
+ (Syncano *)newSyncanoWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(nullable SCCompletionBlock)completion;


/**
 *  Validates existance of an instance on Syncano server
 *
 *  @param completion       completion block
 */
- (void)validateInstanceOnServerWithCompletion:(nullable SCCompletionBlock)completion;

+ (void)enableOfflineStorage;

+ (void)enableOfflineStorageWithCompletionBlock:(nullable SCCompletionBlock)completionBlock;

@end


@interface Syncano (UserManagement)

+ (SCUser *)currenUser;

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(SCCompletionBlock)callback;
- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(SCCompletionBlock)callback;

+ (void)loginWithUserKey:(NSString *)userKey callback:(SCCompletionBlock)callback;
- (void)loginWithUserKey:(NSString *)userKey callback:(SCCompletionBlock)callback;

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion;
- (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion;

+ (void)updatePasswordForCurrentUser:(NSString *)password withCompletion:(SCCompletionBlock)completion;
- (void)updatePasswordForCurrentUser:(NSString *)password withCompletion:(SCCompletionBlock)completion;

+ (void)updatePassword:(NSString *)password forUser:(SCUser *)user withCompletion:(SCCompletionBlock)completion;
- (void)updatePassword:(NSString *)password forUser:(SCUser *)user withCompletion:(SCCompletionBlock)completion;

@end

@interface Syncano (DataEndpoint)

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class callback:(SCDataObjectsCompletionBlock)callback;
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class callback:(SCDataObjectsCompletionBlock)callback;

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters callback:(SCDataObjectsCompletionBlock)callback;
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters callback:(SCDataObjectsCompletionBlock)callback;

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class predicate:(nullable id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback;
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class predicate:(nullable id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback;

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters predicate:(nullable id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback;
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters predicate:(nullable id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback;

#pragma mark -Template

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback;
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback;

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback;
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback;

@end

@interface Syncano (Device)
+ (SCDevice *)registerDeviceWithToken:(NSData *)data callback:(SCCompletionBlock)callback;
- (SCDevice *)registerDeviceWithToken:(NSData *)data callback:(SCCompletionBlock)callback;
@end



NS_ASSUME_NONNULL_END
