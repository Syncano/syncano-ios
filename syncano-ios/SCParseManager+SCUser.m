//
//  SCParseManager+SCUser.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 07/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <objc/runtime.h>
#import "SCParseManager+SCUser.h"
#import "SCParseManager+SCDataObject.h"
#import "SCUser.h"
#import "NSObject+SCParseHelper.h"
#import "UICKeyChainStore/UICKeyChainStore.h"
#import "SCRegisterManager.h"


@implementation SCParseManager (SCUser)

- (void)setUserClass:(__unsafe_unretained Class)userClass {
    objc_setAssociatedObject(self, @selector(userClass), userClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__unsafe_unretained Class)userClass {
    return objc_getAssociatedObject(self, @selector(userClass));
}

- (void)setUserProfileClass:(__unsafe_unretained Class)userProfileClass {
    objc_setAssociatedObject(self, @selector(userProfileClass), userProfileClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (__unsafe_unretained Class)userProfileClass {
    return objc_getAssociatedObject(self, @selector(userProfileClass));
}

- (void)registerUserClass:(__unsafe_unretained Class)classToRegister {
    [self setUserClass:classToRegister];
    [SCRegisterManager registerClass:classToRegister];
}

- (void)registerUserProfileClass:(__unsafe_unretained Class)classToRegister {
    [self setUserProfileClass:classToRegister];
    [SCRegisterManager registerClass:classToRegister];
}

- (id)parsedUserObjectFromJSONObject:(id)JSONObject {
    Class UserClass = ([self userClass]) ? [self userClass] : [SCUser class];
    id user = [UserClass new];
    if ([user respondsToSelector:@selector(fillWithJSONObject:)]) {
        [user fillWithJSONObject:JSONObject];
        NSDictionary *JSONProfile = [JSONObject[kSCUserJSONKeyUserProfile] sc_dictionaryOrNil];
        if (JSONProfile && [user respondsToSelector:NSSelectorFromString(kSCUserJSONKeyUserProfile)]) {
            Class UserProfileClass = ([self userProfileClass]) ? [self userProfileClass] : [SCUserProfile class];
            id profile = [self parsedObjectOfClass:(self.userProfileClass) ? self.userProfileClass : UserProfileClass fromJSONObject:JSONProfile];
            SCValidateAndSetValue(user, kSCUserJSONKeyUserProfile, profile, YES, nil);
        }
        NSString *userKey = [JSONObject[kSCUserJSONKeyUserKey] sc_stringOrEmpty];
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.syncano"];
        keychain[kUserKeyKeychainKey] = userKey;
        return user;
    }
    return nil;
}
@end
