//
//  SCUser.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 06/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserProfile.h"

@class SCPlease;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kSCUserJSONKeyId;
extern NSString *const kSCUserJSONKeyLinks;
extern NSString *const kSCUserJSONKeyUsername;
extern NSString *const kSCUserJSONKeyPassword;
extern NSString *const kSCUserJSONKeyUserKey;
extern NSString *const kSCUserJSONKeyUserProfile;

@interface SCUser : NSObject
@property (nullable,nonatomic,retain) NSNumber *userId;
@property (nullable,nonatomic,retain) NSString *username;
@property (nullable,nonatomic,readonly) NSString *userKey;
@property (nullable,nonatomic,retain) SCUserProfile *profile;
@property (nullable,nonatomic,retain) NSDictionary *links;

/**
 *  Fills SCUser object with data from API
 *
 *  @param JSONObject JSONObject from API
 */
- (void)fillWithJSONObject:(id)JSONObject;

/**
 *  Attempts to get the currently logged in user from disk and returns an instance of it.
 *
 *  @return SCUser instance of currently logged in user or nil
 */
+ (nullable instancetype)currentUser;

/**
 *  Registers user class for subclassing uses
 */
+ (void)registerClass;

/**
 *  Registers user and user_profile class for subclassing uses
 *
 *  @param profileClass class for user_profile
 */

+ (void)registerClassWithProfileClass:(__unsafe_unretained Class)profileClass;

/**
 *  Attempts to login user into singleton Syncano
 *
 *  @param username   username for login
 *  @param password   password for login
 *  @param completion completion block
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(nullable SCCompletionBlock)completion;

/**
 *  Attempts to login user into provided Syncano instance
 *
 *  @param username   username for login
 *  @param password   password for login
 *  @param syncano    syncano instance for login in to
 *  @param completion completion block
 */
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password toSyncano:(Syncano *)syncano completion:(nullable SCCompletionBlock)completion;

/**
 *  Attempts to login user using social authentication into singleton Syncano
 *
 *  @param backend    SCSocialAuthenticationBackend type available options: SCSocialAuthenticationBackendFacebook, SCSocialAuthenticationBackendGoogle, SCSocialAuthenticationBackendLinkedIn, SCSocialAuthenticationBackendTwitter
 *  @param authToken  authToken from social provider
 *  @param completion completion block
 */
+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken completion:(nullable SCCompletionBlock)completion;

/**
 *  Attempts to login user using social authentication into singleton Syncano
 *
 *  @param backend    SCSocialAuthenticationBackend type available options: SCSocialAuthenticationBackendFacebook, SCSocialAuthenticationBackendGoogle, SCSocialAuthenticationBackendLinkedIn, SCSocialAuthenticationBackendTwitter§z
 *  @param authToken  authToken from social provider
 *  @param syncano    syncano instance for login in to
 *  @param completion completion block
 */
+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken toSyncano:(Syncano *)syncano completion:(nullable SCCompletionBlock)completion;

/**
 *  Attempts to register user into singleton Syncano
 *
 *  @param username   username for login
 *  @param password   password for login
 *  @param completion completion block
 */
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(nullable SCCompletionBlock)completion;

/**
 *  Attempts to register user into provided Syncano instance
 *
 *  @param username   username for login
 *  @param password   password for login
 *  @param syncano    syncano instance for login in to
 *  @param completion completion block
 */
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password inSyncano:(Syncano *)syncano completion:(nullable SCCompletionBlock)completion;

/**
 *  Attempts to register user into singleton Syncano,
 *  but does not automatically login that user. It returns the newly created user in the completion block
 *
 *  @param username   username for login
 *  @param password   password for login
 *  @param completion completion block
 */
+ (void)addNewUserWithUsername:(NSString *)username password:(NSString *)password completionBlock:(nullable SCCompletionBlockWithUser)completion;

/**
 *  Attempts to register user into provided Syncano instance,
 *  but does not automatically login that user. It returns the newly created user in the completion block
 *
 *  @param username   username for login
 *  @param password   password for login
 *  @param syncano    syncano instance for login in to
 *  @param completion completion block
 */
+ (void)addNewUserWithUsername:(NSString *)username password:(NSString *)password inSyncano:(Syncano *)syncano completionBlock:(nullable SCCompletionBlockWithUser)completion;
    
/**
 *  Returns SCPlease instance for singleton Syncano
 *
 *  @return SCPlease instance
 */
+ (nullable SCPlease *)please;

/**
 *  Returns SCPlease instance for provided Syncano instance
 *
 *  @param syncano Syncano instance which SCPlease will be using to query objects from
 *
 *  @return SCPlease instance
 */
+ (nullable SCPlease *)pleaseFromSyncano:(Syncano *)syncano;

/**
 *  Logs out current user
 */
- (void)logout;

/**
 *  Updates username in singleton Syncano instance
 *
 *  @param username   new username
 *  @param completion completion block
 */
- (void)updateUsername:(NSString *)username withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Updates username in singleton Syncano instance
 *
 *  @param username   new username
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
- (void)updateUsername:(NSString *)username inSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Updates user password in singleton Syncano instance
 *
 *  @param password   new password
 *  @param completion completion block
 */
- (void)updatePassword:(NSString *)username withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Updates user password in singleton Syncano instance
 *
 *  @param password   new password
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
- (void)updatePassword:(NSString *)username inSyncno:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END