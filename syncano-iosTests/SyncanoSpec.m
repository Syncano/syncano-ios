//
//  SyncanoSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 26/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

SPEC_BEGIN(SyncanoSpec)

describe(@"Syncano", ^{
    
    context(@"environment variables test", ^{
       it(@"should get env var", ^{
           NSDictionary *environment = [[NSProcessInfo processInfo] environment];
           NSString *apikey = environment[@"apikey"];
           [[apikey shouldNot] beNil];
           [[apikey should] equal:@"somekey"];
       });
    });
    
     context(@"singleton syncano instance", ^{
        beforeAll(^{
            [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        });
        it(@"should set api key", ^{
            [[[Syncano getApiKey] should] equal:@"API-KEY"];
        });
        it(@"should set instance name", ^{
            [[[Syncano getInstanceName] should] equal:@"INSTANCE-NAME"];
        });
         
         context(@"with validation", ^{
            it(@"should create singletone instance and validate it with server", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                    // Stub it with our "wsresponse.json" stub file
                    return [OHHTTPStubsResponse responseWithData:[NSData new]
                                                            statusCode:200 headers:nil];
                }];
                __block NSError *_error;
                __block BOOL _blockFinished;
                [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME" andValidateWithCompletion:^(NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[[Syncano getApiKey] shouldEventually] equal:@"API-KEY"];
                [[[Syncano getInstanceName] shouldEventually] equal:@"INSTANCE-NAME"];

            });
         });
     });
    
    context(@"custom syncano instance", ^{
        Syncano *syncano = [[Syncano alloc] initWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];

        it(@"should set api key", ^{
            [[[syncano apiKey] should] equal:@"API-KEY"];
        });
        it(@"should set instance name", ^{
            [[[syncano instanceName] should] equal:@"INSTANCE-NAME"];
        });
        
        context(@"with validation", ^{
            it(@"should create instance and validate it with server", ^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                    // Stub it with our "wsresponse.json" stub file
                    return [OHHTTPStubsResponse responseWithData:[NSData new]
                                                      statusCode:200 headers:nil];
                }];
                __block NSError *_error;
                __block BOOL _blockFinished;
                Syncano *syncano = [[Syncano alloc] initWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME" andValidateWithCompletion:^(NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[syncano.apiKey shouldEventually] equal:@"API-KEY"];
                [[syncano.instanceName shouldEventually] equal:@"INSTANCE-NAME"];
                
            });
        });
    });

});

SPEC_END
