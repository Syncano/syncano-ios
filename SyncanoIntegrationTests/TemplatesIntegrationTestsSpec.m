//
//  TemplatesIntegrationTestsSpec.m
//  syncano-ios
//
//  Created by Jan Lipmann on 12.05.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "Book.h"
#import "SCPleaseForTemplate.h"

SPEC_BEGIN(TemplatesIntegrationTestsSpec)

describe(@"Templates", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    
    [Book registerClass];
    [Author registerClass];
    
    context(@"Fetch data with template", ^{
        
        __block NSError *_error;
        __block BOOL _blockFinished = NO;
        __block id _responseObject;
        it(@"should text", ^{
            
            [[Book pleaseForTemplate:@"itworks"] giveMeDataWithParameters:nil completion:^(id responseObject, NSError *error) {
                _blockFinished = YES;
                _responseObject = responseObject;
                _error = error;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            NSString *responseString = [[NSString alloc] initWithData:(NSData *)_responseObject encoding:NSUTF8StringEncoding];
            [[responseString should] equal:@"It Works!"];
        });
    });
    
});

SPEC_END
