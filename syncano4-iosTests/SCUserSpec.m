//
//  SCUserSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 6/07/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "KWSpec+WaitFor.h"
#import <OHHTTPStubs.h>
#import "Syncano.h"
#import "SCUser.h"
#import "CustomUserProfile.h"
#import "SCPlease.h"

SPEC_BEGIN(SCUserSpec)

describe(@"SCUser", ^{
    
    afterAll(^{
        [[SCUser currentUser] logout];
    });
    
    context(@"singleton syncano instance", ^{
        beforeAll(^{
            [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        });
        
        it(@"should register", ^{
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                // Stub it with our "wsresponse.json" stub file
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserRegister.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block SCUser *registereddUser;
            [SCUser registerWithUsername:@"zenon" password:@"rtw57hwggwt6" completion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
                registereddUser = [SCUser currentUser];
                //[SCCannedURLProtocol unregisterFromAPIClient:syncano.apiClient];
                
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[registereddUser shouldEventually] beNonNil];
        });
        
        
        
        it(@"should login and logout", ^{
            
            //Login
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block SCUser *loggedUser;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [SCUser loginWithUsername:@"janek" password:@"qaz123" completion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
                loggedUser = [SCUser currentUser];
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[loggedUser shouldEventually] beNonNil];
            [[[loggedUser userKey] shouldEventually] beNonNil];
            [[[loggedUser username] shouldEventually] beNonNil];
            
            //Log out
            [loggedUser logout];
            [[[loggedUser userKey] should] beNil];
        });
        
        it(@"should update username", ^{
            __block SCUser *loggedUser;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            [SCUser loginWithUsername:@"janek" password:@"qaz123" completion:^(NSError *error) {
                _error = error;
                if(error) {
                    _blockFinished = YES;
                } else {
                    loggedUser = [SCUser currentUser];
                    [loggedUser updateUsername:@"marek" withCompletion:^(NSError *error) {
                        _error = error;
                        _blockFinished = YES;
                    }];
                }
            }];
            
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[loggedUser shouldEventually] beNonNil];
            [[loggedUser.username shouldEventually] equal:@"marek"];
        });
        
        it(@"should update password", ^{
            __block SCUser *loggedUser;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            [SCUser loginWithUsername:@"janek" password:@"qaz123" completion:^(NSError *error) {
                _error = error;
                if(error) {
                    _blockFinished = YES;
                } else {
                    loggedUser = [SCUser currentUser];
                    [loggedUser updatePassword:@"marek" withCompletion:^(NSError *error) {
                        _error = error;
                        _blockFinished = YES;
                    }];
                }
            }];
            
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
        });

        it(@"should return SCPlease instance", ^{
            SCPlease *please = [SCUser please];
            [[please shouldNot] beNil];
            [[please should] beKindOfClass:[SCPlease class]];
        });
        
    });

    
    context(@"custom syncano instance", ^{
        Syncano *syncano = [[Syncano alloc] initWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        afterAll(^{
            [[SCUser currentUser] logout];
        });
        
        it(@"should register", ^{
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                // Stub it with our "wsresponse.json" stub file
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserRegister.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block SCUser *registereddUser;
            [SCUser registerWithUsername:@"zenon" password:@"rtw57hwggwt6" inSyncano:syncano completion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
                registereddUser = [SCUser currentUser];
                //[SCCannedURLProtocol unregisterFromAPIClient:syncano.apiClient];

            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[registereddUser shouldEventually] beNonNil];
        });
        
        
        
        it(@"should login and logout", ^{
            
            //Login
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
            [[loggedUser shouldEventually] beNonNil];
            [[[loggedUser userKey] shouldEventually] beNonNil];
            [[[loggedUser username] shouldEventually] beNonNil];
            
            //Log out
            [loggedUser logout];
            [[[loggedUser userKey] should] beNil];
        });
        
        it(@"should update username", ^{
            __block SCUser *loggedUser;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            [SCUser loginWithUsername:@"janek" password:@"qaz123" toSyncano:syncano completion:^(NSError *error) {
                _error = error;
                if(error) {
                    _blockFinished = YES;
                } else {
                    loggedUser = [SCUser currentUser];
                    [loggedUser updateUsername:@"marek" inSyncano:syncano withCompletion:^(NSError *error) {
                        _error = error;
                        _blockFinished = YES;
                    }];
                }
            }];
            
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[loggedUser shouldEventually] beNonNil];
            [[loggedUser.username shouldEventually] equal:@"marek"];
        });

        it(@"should update password", ^{
            __block SCUser *loggedUser;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            [SCUser loginWithUsername:@"janek" password:@"qaz123" toSyncano:syncano completion:^(NSError *error) {
                _error = error;
                if(error) {
                    _blockFinished = YES;
                } else {
                    loggedUser = [SCUser currentUser];
                    [loggedUser updatePassword:@"marek" inSyncno:syncano withCompletion:^(NSError *error) {
                        _error = error;
                        _blockFinished = YES;
                    }];
                }
            }];
            
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
        });

        it(@"should return SCPlease instance", ^{
            SCPlease *please = [SCUser pleaseFromSyncano:syncano];
            [[please shouldNot] beNil];
            [[please should] beKindOfClass:[SCPlease class]];
        });
    });
    
    context(@"custom user profile", ^{
        it(@"should register class", ^{
            __block SCUser *user;
            __block BOOL _blockFinished;
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            [SCUser registerClassWithProfileClass:[CustomUserProfile class]];
            [[SCUser currentUser] logout];
            [SCUser loginWithUsername:@"janek" password:@"qaz123" completion:^(NSError *error) {
                user = [SCUser currentUser];
                _blockFinished = YES;
                
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[user.profile should] beKindOfClass:[CustomUserProfile class]];
            [[SCUser currentUser] logout];
        });
    });
    
    
    context(@"default user profile", ^{
        it(@"should register class", ^{
            
            __block SCUser *user;
            __block BOOL _blockFinished;
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"SCUserLogin.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            [SCUser registerClass];
            [[SCUser currentUser] logout];
            [SCUser loginWithUsername:@"janek" password:@"qaz123" completion:^(NSError *error) {
                user = [SCUser currentUser];
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[user.profile should] beKindOfClass:[SCUserProfile class]];
            
        });
    });

    it(@"should fill object with JSON dictionary", ^{
        NSDictionary *JSONDictioonary = @{@"id" : @12,
                                          @"username" : @"janek",
                                          @"links" : @{@"profile":@"/v1/instances/mytestinstance/classes/user_profile/objects/85/",@"self":@"/v1/instances/mytestinstance/users/1/",@"groups":@"/v1/instances/mytestinstance/users/1/groups/",@"reset-key":@"/v1/instances/mytestinstance/users/1/reset_key/"}};
        
        SCUser *user = [SCUser new];
        [user fillWithJSONObject:JSONDictioonary];
        
        [[user.userId should] equal:@12];
        [[user.username should] equal:@"janek"];
        [[user.links shouldNot] beNil];
        [[user.links should] beKindOfClass:[NSDictionary class]];
    });
    
});

SPEC_END
