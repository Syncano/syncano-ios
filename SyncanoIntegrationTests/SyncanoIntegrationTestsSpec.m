//
//  SyncanoIntegrationTests.m
//  SyncanoIntegrationTests
//
//  Created by Jan Lipmann on 20/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"

SPEC_BEGIN(SyncanoIntegrationTestsSpec)

describe(@"Syncano", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apikey = environment[@"API_KEY"];
    NSString *instanceName = @"ancient-firefly-1371";
    
    context(@"environment variables test", ^{
        
        
        
        it(@"should get env var", ^{
            [[apikey shouldNot] beNil];            
        });
    });
    
    context(@"syncno instance with validation", ^{
        it(@"should create singletone instance and validate it with server", ^{
            __block NSError *_error;
            __block BOOL _blockFinished;
            [Syncano sharedInstanceWithApiKey:apikey instanceName:instanceName andValidateWithCompletion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[[Syncano getApiKey] shouldEventually] equal:apikey];
            [[[Syncano getInstanceName] shouldEventually] equal:instanceName];
            
        });
    });
    
    
});

SPEC_END