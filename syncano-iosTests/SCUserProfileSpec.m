//
//  SCUserSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 6/07/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import <OHHTTPStubs.h>
#import "Syncano.h"

SPEC_BEGIN(SCUserProfileSpec)

describe(@"SCUserProfile", ^{
    Syncano *syncano = [[Syncano alloc] initWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
    
    it(@"should have proper owner id", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        
        __block SCUser *loggedUser;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [SCUser loginWithUsername:@"janek" password:@"qaz123" toSyncano:syncano completion:^(NSError *error) {
            _error = error;
            _blockFinished = YES;
            loggedUser = [SCUser currentUser];
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[loggedUser.profile.owner should] equal:loggedUser.userId];
        [loggedUser logout];
    });
});

SPEC_END
