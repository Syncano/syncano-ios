//
//  UserLoginSpec.m
//  syncano-ios
//
//  Created by Jakub Machoń on 28.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"

/**
 *  You should set GOOGLE_TOKEN_KEY, FACEBOOK_TOKEN_KEY, TWITTER_TOKEN_KEY, LINKEDIN_TOKEN_KEY for this tests to work
 */
SPEC_BEGIN(UserLoginSpec)

describe(@"User login", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apikey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apikey instanceName:instanceName];
    });
    
    afterEach(^{
        [[SCUser currentUser] logout];
    });
    
    void (^testSocialLogin)(NSString*,int) = ^(NSString *token, int backend) {
        
        NSLog(@"token: %@",token);
        if(token != nil) {//enable test
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            [[[SCUser currentUser] should] beNil];
            [SCUser loginWithSocialBackend:backend authToken:token completion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[[SCUser currentUser] shouldNotEventually] beNil];
            [[_error shouldEventually] beNil];
            
        }
    };
    
    //Below "sharedExamplesFor" from Kiwi should be used but it didn't want to work with xctool :(
    
    it(@"should login with Google", ^{
        if(![environment[@"GOOGLE_TOKEN_KEY"] isEqualToString:@"$GOOGLE_TOKEN_KEY"])
            testSocialLogin(environment[@"GOOGLE_TOKEN_KEY"],SCSocialAuthenticationBackendGoogle);
    });
    
    it(@"should login with Facebook", ^{
        if(![environment[@"FACEBOOK_TOKEN_KEY"] isEqualToString:@"$FACEBOOK_TOKEN_KEY"])
            testSocialLogin(environment[@"FACEBOOK_TOKEN_KEY"],SCSocialAuthenticationBackendFacebook);
    });
    
    it(@"should login with Twitter", ^{
        if(![environment[@"TWITTER_TOKEN_KEY"] isEqualToString:@"$TWITTER_TOKEN_KEY"])
            testSocialLogin(environment[@"TWITTER_TOKEN_KEY"],SCSocialAuthenticationBackendTwitter);
    });
    
    it(@"should login with LinkedIn", ^{
        if(![environment[@"LINKEDIN_TOKEN_KEY"] isEqualToString:@"$LINKEDIN_TOKEN_KEY"])
            testSocialLogin(environment[@"LINKEDIN_TOKEN_KEY"],SCSocialAuthenticationBackendLinkedIn);
    });
});

SPEC_END
