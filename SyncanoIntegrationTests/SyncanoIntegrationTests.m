//
//  SyncanoIntegrationTests.m
//  SyncanoIntegrationTests
//
//  Created by Jan Lipmann on 20/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"

SPEC_BEGIN(SyncanoSpec)

describe(@"Syncano", ^{
    
    context(@"environment variables test", ^{
        it(@"should get env var", ^{
            NSDictionary *environment = [[NSProcessInfo processInfo] environment];
            NSString *apikey = environment[@"API_KEY"];
            [[apikey shouldNot] beNil];
            [[apikey should] equal:@"ABCD"];
        });
    });
    
    
    
});

SPEC_END