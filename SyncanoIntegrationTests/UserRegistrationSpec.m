//
//  UserRegistrationSpec.m
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 2/19/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "NSString+MD5.h"

SPEC_BEGIN(UserRegistrationSpec)

describe(@"User registration", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    });
    
    afterEach(^{
        [[SCUser currentUser] logout];
    });
    
    it(@"should add new user", ^{
        NSString *uniqueHash = [[NSString stringWithFormat:@"%@-%@",[NSUUID UUID].UUIDString,[NSDate date]] sc_MD5String];
        NSString *username = [NSString stringWithFormat:@"user-%@",uniqueHash];
        NSString *password = @"password";
        if(username != nil && password != nil) {//enable test
            __block NSError *_error;
            __block BOOL _blockFinished = NO;
            __block SCUser *_registeredUser = nil;
            
            [[[SCUser currentUser] should] beNil];
            [SCUser addNewUserWithUsername:username password:password completionBlock:^(SCUser *user, NSError *error) {
                _error = error;
                _blockFinished = YES;
                _registeredUser = user;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[[SCUser currentUser] shouldEventually] beNil];
            [[_error shouldEventually] beNil];
            [[_registeredUser shouldEventually] beNonNil];
            [[[_registeredUser username] shouldEventually] equal:username];
        }
    });
    
});

SPEC_END