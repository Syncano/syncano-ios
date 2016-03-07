//
//  SCUser+UserDefaults.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 2/12/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCUser.h"

@interface SCUser (UserDefaults)

+ (id)JSONUserDataFromDefaults;
+ (void)saveJSONUserData:(id)JSONUserData;
+ (void)removeUserFromDefaults;
+ (void)updateUsernameStoredInDefaults:(NSString *)username;
+ (void)updateUserProfileStoredInDefaults:(SCUserProfile *)profile;

+ (NSString *)userKeyFromDefaults;

@end
