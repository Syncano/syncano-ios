//
//  SCUser+UserDefaults.m
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 2/12/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCUser+UserDefaults.h"
#import "NSObject+SCParseHelper.h"

NSString *const kCurrentUser = @"com.syncano.kCurrentUser";

@implementation SCUser (UserDefaults)

+ (id)JSONUserDataFromDefaults {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUser];
    if (data) {
        id userData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return userData;
    }
    return nil;
}

+ (void)saveJSONUserData:(id)JSONUserData {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:JSONUserData];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserFromDefaults {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUser];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)userKeyFromDefaults {
    NSString *userKey = nil;
    id jsonUserData = [self JSONUserDataFromDefaults];
    if ([jsonUserData respondsToSelector:@selector(objectForKey:)]) {
        userKey = [jsonUserData[@"user_key"] sc_stringOrEmpty];
    }
    return userKey;
}

@end
