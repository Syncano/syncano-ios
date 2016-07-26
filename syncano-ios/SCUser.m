//
//  SCUser.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 06/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//
#import "Syncano.h"
#import "SCUser.h"
#import "SCPlease.h"
#import "SCAPIClient.h"
#import "NSObject+SCParseHelper.h"
#import "SCParseManager+SCUser.h"
#import "NSObject+SCParseHelper.h"
#import "SCUser+UserDefaults.h"

static id _currentUser;

NSString *const kSCUserJSONKeyId = @"id";
NSString *const kSCUserJSONKeyLinks = @"links";
NSString *const kSCUserJSONKeyUsername = @"username";
NSString *const kSCUserJSONKeyPassword = @"password";
NSString *const kSCUserJSONKeyUserKey = @"user_key";
NSString *const kSCUserJSONKeyUserProfile = @"profile";

@implementation SCUser

- (void)fillWithJSONObject:(id)JSONObject {
    self.userId = [JSONObject[kSCUserJSONKeyId] sc_numberOrNil];
    self.username = [JSONObject[kSCUserJSONKeyUsername] sc_stringOrEmpty];
    self.links = [JSONObject[kSCUserJSONKeyLinks] sc_dictionaryOrNil];
}

- (NSString *)userKey {
    return [[self class] userKeyFromDefaults];
}

+ (NSDictionary *)paramsForAuthToken:(NSString *)authToken {
    if (authToken.length <= 0) {
        return nil;
    }
    return @{@"access_token":authToken};
}

+ (instancetype)currentUser {
    if (_currentUser) {
        return _currentUser;
    }
    id archivedUserData = [self JSONUserDataFromDefaults];
    if (archivedUserData) {
        _currentUser = [[SCParseManager sharedSCParseManager] parsedUserObjectFromJSONObject:archivedUserData];
        return _currentUser;
    }
    return nil;
}

+ (void)registerClass {
    [self _registerClassWithProfileClass:nil];
}

+(void)registerClassWithProfileClass:(__unsafe_unretained Class)profileClass {
    [self _registerClassWithProfileClass:profileClass];
}

+(void)_registerClassWithProfileClass:(__unsafe_unretained Class)profileClass {
    [[SCParseManager sharedSCParseManager] registerUserClass:[self class]];
    if (profileClass) {
        [[SCParseManager sharedSCParseManager] registerUserProfileClass:profileClass];
    } else {
        [[SCParseManager sharedSCParseManager] registerUserProfileClass:[SCUserProfile class]];
    }
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion{
    [self loginWithUsername:username password:password usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password toSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self loginWithUsername:username password:password usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password usingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    [self sweepLoggedInUserData];
    NSDictionary *params = @{kSCUserJSONKeyUsername : username , kSCUserJSONKeyPassword : password};
    [apiClient POSTWithPath:@"user/auth/" params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(error);
        } else {
            [self saveJSONUserData:responseObject];
            completion(nil);
        }
    }];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion {
    [self registerWithUsername:username password:password usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password inSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self registerWithUsername:username password:password usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password usingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    //TODO: validate if username and password are not empty or maybe leave it to API :)
    NSDictionary *params = @{kSCUserJSONKeyUsername : username , kSCUserJSONKeyPassword : password};
    [apiClient POSTWithPath:@"users/" params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(error);
        } else {
            [self saveJSONUserData:responseObject];
            completion(nil);
        }
    }];
}


+ (void)registerWithUsername:(NSString *)username password:(NSString *)password userProfile:(SCUserProfile *)userProfile completion:(SCCompletionBlock)completion {
    [self registerWithUsername:username password:password userProfile:userProfile usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password userProfile:(SCUserProfile *)userProfile inSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self registerWithUsername:username password:password userProfile:userProfile usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password userProfile:(SCUserProfile *)userProfile usingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    NSError *serializeError;
    NSDictionary *userProfileJSONSerialized = [[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:userProfile error:&serializeError];
    if (serializeError != nil) {
        if (completion) {
            completion(serializeError);
        }
        return;
    }
    NSDictionary *params = @{kSCUserJSONKeyUsername : username , kSCUserJSONKeyPassword : password , kSCUserJSONKeyUserProfile : userProfileJSONSerialized};
    [apiClient POSTWithPath:@"users/" params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(error);
        } else {
            [self saveJSONUserData:responseObject];
            completion(nil);
        }
    }];
}

+ (void)addNewUserWithUsername:(NSString *)username password:(NSString *)password completionBlock:(SCCompletionBlockWithUser)completion {
    [self addNewUserWithUsername:username password:password usingAPIClient:[Syncano sharedAPIClient] completionBlock:completion];
}

+ (void)addNewUserWithUsername:(NSString *)username password:(NSString *)password inSyncano:(Syncano *)syncano completionBlock:(SCCompletionBlockWithUser)completion {
    [self addNewUserWithUsername:username password:password usingAPIClient:syncano.apiClient completionBlock:completion];
}

+ (void)addNewUserWithUsername:(NSString *)username password:(NSString *)password usingAPIClient:(SCAPIClient *)apiClient completionBlock:(SCCompletionBlockWithUser)completion {
    NSDictionary *params = @{@"username" : username , @"password" : password};
    [apiClient postTaskWithPath:@"users/" params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            SCUser *newUser = [[SCParseManager sharedSCParseManager] parsedUserObjectFromJSONObject:responseObject];
            completion(newUser, nil);
        }
    }];
}

+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken completion:(SCCompletionBlock)completion {
    [self loginWithSocialBackend:backend authToken:authToken usingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken toSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self loginWithSocialBackend:backend authToken:authToken usingAPIClient:syncano.apiClient completion:completion];
}

+ (void)loginWithSocialBackend:(SCSocialAuthenticationBackend)backend authToken:(NSString *)authToken usingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    [self sweepLoggedInUserData];
    NSString *path = [NSString stringWithFormat:@"user/auth/%@/", [SCConstants socialAuthenticationBackendToString:backend]];
    [apiClient POSTWithPath:path params:[self paramsForAuthToken:authToken] completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (error) {
            completion(error);
        } else {
            [self saveJSONUserData:responseObject];
            completion(nil);
        }
    }];

}

- (void)logout {
    [[self class] sweepLoggedInUserData];
}

+ (void)sweepLoggedInUserData {
    [self removeUserFromDefaults];
    _currentUser = nil;
}

+ (SCPlease *)please {
    return [SCUserProfile please];
}

+ (SCPlease *)pleaseFromSyncano:(Syncano *)syncano {
    return [SCUserProfile pleaseFromSyncano:syncano];
}

- (void)updateUsername:(NSString *)username withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:username password:nil usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}
- (void)updateUsername:(NSString *)username inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:username password:nil usingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)updatePassword:(NSString *)password withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:nil password:password usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}
- (void)updatePassword:(NSString *)password inSyncno:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self updateUsername:nil password:password usingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)updateUsername:(NSString *)username password:(NSString *)password usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (username.length > 0) {
        self.username = username;
        [params setObject:username forKey:kSCUserJSONKeyUsername];
    }
    if (password.length > 0) {
        [params setObject:password forKey:kSCUserJSONKeyPassword];
    }
    NSString *path = @"user/";
    [apiClient PATCHWithPath:path params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        NSString *username = [responseObject[kSCUserJSONKeyUsername] sc_stringOrEmpty];
        [[self class] updateUsernameStoredInDefaults:username];
        completion(error);
    }];
}

@end
