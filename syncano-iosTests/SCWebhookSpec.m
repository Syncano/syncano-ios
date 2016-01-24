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


SPEC_BEGIN(SCWebhookSpec)

describe(@"SCWebhook", ^{
    context(@"singleton Syncano instance", ^{
        it(@"should run webhook with name", ^{
            [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Webhook.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block SCWebhookResponseObject *_responseObject;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [SCWebhook runWebhookWithName:@"TEST-NAME" completion:^(SCWebhookResponseObject *responseObject, NSError *error) {
                _responseObject = responseObject;
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[_responseObject shouldEventually] beNonNil];
        });
        
        it(@"should run webhook with name and payload", ^{
            [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Webhook.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block SCWebhookResponseObject *_responseObject;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            NSDictionary *payload = @{@"monster":@"Manticore"};
            [SCWebhook runWebhookWithName:@"TEST-NAME" withPayload:payload completion:^(SCWebhookResponseObject *responseObject, NSError *error) {
                _responseObject = responseObject;
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[_responseObject shouldEventually] beNonNil];
            [[_responseObject.result[@"stdout"] should] equal:@"Killed Manticore"];
        });
 
        it(@"should run webhook with custom response", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [[request.URL absoluteString] isEqualToString:@"https://api.syncano.io/v1/instances/INSTANCE-NAME/webhooks/WEBHOOK-NAME/run/"];
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"CustomResponse",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            id responseSerializer = [Syncano sharedAPIClient].responseSerializer;
            __block NSData *_responseObject;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [SCWebhook runCustomWebhookWithName:@"WEBHOOK-NAME" completion:^(id responseObject, NSError *error) {
                _responseObject = (NSData*)responseObject;
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
        
    });
    
    context(@"custom Syncano instance", ^{
        it(@"should webhook", ^{
            Syncano *syncano =  [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block SCWebhookResponseObject *_responseObject;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            [SCWebhook runWebhookWithName:@"TEST-NAME" onSyncano:syncano completion:^(SCWebhookResponseObject *responseObject, NSError *error) {
                _responseObject = responseObject;
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[_responseObject shouldEventually] beNonNil];

        });
        
        it(@"should run webhook with name and payload", ^{
            Syncano *syncano =  [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Webhook.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block SCWebhookResponseObject *_responseObject;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            NSDictionary *payload = @{@"monster":@"Manticore"};
            [SCWebhook runWebhookWithName:@"TEST-NAME" withPayload:payload onSyncano:syncano completion:^(SCWebhookResponseObject *responseObject, NSError *error) {
                _responseObject = responseObject;
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[_responseObject shouldEventually] beNonNil];
            [[_responseObject.result[@"stdout"] should] equal:@"Killed Manticore"];
        });
        
        it(@"should run webhook with custom response", ^{
            Syncano *syncano =  [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME-CUSTOM"];
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return [[request.URL absoluteString] isEqualToString:@"https://api.syncano.io/v1/instances/INSTANCE-NAME-CUSTOM/webhooks/WEBHOOK-NAME/run/"];
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block NSDictionary *_responseObject;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [SCWebhook runCustomWebhookWithName:@"WEBHOOK-NAME" onSyncano:syncano completion:^(id responseObject, NSError *error) {
                _responseObject = (NSDictionary*)responseObject;
                _error = error;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[_responseObject shouldEventually] beNonNil];
            NSString* responseString = _responseObject[@"status"];
            [[responseString should] equal:@"pending"];
            
        });
    });
    
    it(@"should run public webhook", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Webhook.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block SCWebhookResponseObject *_responseObject;
        __block NSError *_error;
        __block BOOL _blockFinished;        
        [SCWebhook runPublicWebhookWithHash:@"HASH" name:@"WEBHOOK-NAME" params:nil forInstanceName:@"INSTANCE-NAME" completion:^(SCWebhookResponseObject *responseObject, NSError *error) {
            _responseObject = responseObject;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_responseObject shouldEventually] beNonNil];
        [[_responseObject.result[@"stdout"] should] equal:@"Killed Manticore"];

    });
    
    it(@"should run public webhook with custom response", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [[request.URL absoluteString] isEqualToString:@"https://api.syncano.io/v1/instances/INSTANCE-NAME/webhooks/p/HASH/WEBHOOK-NAME/"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"CustomResponse",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        id responseSerializer = [Syncano sharedAPIClient].responseSerializer;
        __block NSData *_responseObject;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [SCWebhook runCustomPublicWebhookWithHash:@"HASH" name:@"WEBHOOK-NAME" params:nil forInstanceName:@"INSTANCE-NAME" completion:^(id responseObject, NSError *error) {
            _responseObject = (NSData*)responseObject;
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
    
});

SPEC_END
