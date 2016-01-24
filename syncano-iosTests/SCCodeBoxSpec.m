//
//  SCAPISpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHPathHelpers.h"


SPEC_BEGIN(SCCodeBoxSpec)

describe(@"SCCodeBox", ^{
    it(@"should run code box on singleton Syncano instance", ^{
        [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block SCTrace *_trace;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [SCCodeBox runCodeBoxWithId:@1 params:nil completion:^(SCTrace *trace, NSError *error) {
            _trace = trace;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_trace shouldEventually] beNonNil];
    });
    
    it(@"should run code box with custom response on singleton Syncano instance", ^{
        [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [[request.URL absoluteString] isEqualToString:@"https://api.syncano.io/v1/instances/INSTANCE-NAME/codeboxes/1/run/"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"CustomResponse",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        id responseSerializer = [Syncano sharedAPIClient].responseSerializer;
        __block NSData *_responseObject;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [SCCodeBox runCustomCodeBoxWithId:@1 params:nil completion:^(id responseObject, NSError *error) {
            _responseObject = responseObject;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_responseObject shouldEventually] beNonNil];
        NSString* responseString = [[NSString alloc] initWithData:_responseObject encoding:NSUTF8StringEncoding];
        [[responseString should] equal:@"It works!"];
        [[[Syncano sharedAPIClient].responseSerializer should] beIdenticalTo:responseSerializer];
    });
    
    it(@"should run code box on provided Syncano instance", ^{
       Syncano *syncano =  [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block SCTrace *_trace;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [SCCodeBox runCodeBoxWithId:@1 params:nil onSyncano:syncano completion:^(SCTrace *trace, NSError *error) {
            _trace = trace;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_trace shouldEventually] beNonNil];
    });
    
    it(@"should run code box with custom response on singleton Syncano instance", ^{
        Syncano *syncano =  [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME-CUSTOM"];
        
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [[request.URL absoluteString] isEqualToString:@"https://api.syncano.io/v1/instances/INSTANCE-NAME-CUSTOM/codeboxes/1/run/"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Webhook.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block NSDictionary *_responseObject;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [SCCodeBox runCustomCodeBoxWithId:@1 params:nil onSyncano:syncano completion:^(id responseObject, NSError *error) {
            _responseObject = responseObject;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_responseObject shouldEventually] beNonNil];
        NSString* responseString = _responseObject[@"status"];
        [[responseString should] equal:@"success"];
    });
});

SPEC_END
