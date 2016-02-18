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
#import "SCAPIClient+SCFile.h"
#import "SCAPIClient+SCDataObject.h"

SPEC_BEGIN(SCAPIClientSpec)

describe(@"SCAPIClient", ^{
    
    beforeAll(^{
        [[SCUser currentUser] logout];
    });
    
    context(@"main class", ^{
        Syncano *syncano = [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        it(@"should properly create new API client for Syncano instance", ^{
            SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];

            NSURL *instanceURL = [NSURL URLWithString:@"INSTANCE-NAME/" relativeToURL:[NSURL URLWithString:kBaseURL]];
            [[apiClient.baseURL should] equal:instanceURL];
        });
        
        context(@"data tasks", ^{
            
            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithData:[NSData new]
                                                            statusCode:200 headers:nil];
                }];
            });
            
            it(@"should create, authorize and call GET task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH?param=value",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                __block NSURLSessionDataTask *_task;
                [apiClient GETWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                    _task = task;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error should] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[_task.currentRequest.HTTPMethod should] equal:@"GET"];
                [[_task.currentRequest.URL should] equal:url];
                [[_task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
            });
            it(@"should create, authorize and call POST task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                __block NSURLSessionDataTask *_task;
                [apiClient POSTWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                    _task = task;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error should] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[_task.currentRequest.HTTPMethod should] equal:@"POST"];
                [[_task.currentRequest.URL should] equal:url];
                [[_task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
                NSData *httpBody = [NSJSONSerialization dataWithJSONObject:@{@"param" : @"value"} options:0 error:nil];
                [[_task.originalRequest.HTTPBody should] equal:httpBody];
            });
            
            it(@"should create, authorize and call PUT task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                __block NSURLSessionDataTask *_task;
                [apiClient PUTWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                    _task = task;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error should] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[_task.currentRequest.HTTPMethod should] equal:@"PUT"];
                [[_task.currentRequest.URL should] equal:url];
                [[_task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
                NSData *httpBody = [NSJSONSerialization dataWithJSONObject:@{@"param" : @"value"} options:0 error:nil];
                [[_task.originalRequest.HTTPBody should] equal:httpBody];
            });
            
            it(@"should create, authorize and call PATCH task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                __block NSURLSessionDataTask *_task;
                [apiClient PATCHWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                    _task = task;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error should] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[_task.currentRequest.HTTPMethod should] equal:@"PATCH"];
                [[_task.currentRequest.URL should] equal:url];
                [[_task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
                NSData *httpBody = [NSJSONSerialization dataWithJSONObject:@{@"param" : @"value"} options:0 error:nil];
                [[_task.originalRequest.HTTPBody should] equal:httpBody];
            });
            
            it(@"should create, authorize and call DELETE task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH?param=value",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                __block NSURLSessionDataTask *_task;
                [apiClient DELETEWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                    _task = task;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error should] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[_task.currentRequest.HTTPMethod should] equal:@"DELETE"];
                [[_task.currentRequest.URL should] equal:url];
                [[_task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
            });
        });
    });
    
    context(@"SCFile category", ^{
        it(@"should download file", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"syncano-white.png",self.class)
                                                        statusCode:200 headers:nil];
            }];
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block id _responseobject;
            [SCAPIClient downloadFileFromURL:[NSURL URLWithString:@"FILE-URL"] withCompletion:^(id responseObject, NSError *error) {
                _error = error;
                _responseobject = responseObject;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error should] beNil];
            
            NSData *reference = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"syncano-white" ofType:@"png"]];
            
            [[_responseobject should] beKindOfClass:[NSData class]];
            [[_responseobject should] equal:reference];
        });
    });
    
    context(@"SCDataObject category", ^{
       Syncano *syncano = [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        it(@"should get data objects for class with name", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block id _responseobject;
            __block NSURLSessionDataTask *_task;

            SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/classes/book/objects/",kBaseURL]];
            [apiClient getDataObjectsFromClassName:@"book" params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                _error = error;
                _responseobject = responseObject;
                _blockFinished = YES;
                _task = task;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error should] beNil];
            [[_task.currentRequest.HTTPMethod should] equal:@"GET"];
            [[_task.currentRequest.URL should] equal:url];
            [[_task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
            [[_responseobject[@"objects"] should] beKindOfClass:[NSArray class]];
       });
        
        it(@"should get data object for class with name and with id", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block id _responseobject;
            __block NSURLSessionDataTask *_task;
            SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/classes/book/objects/2/",kBaseURL]];
            [apiClient getDataObjectsFromClassName:@"book" withId:@2 completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                _error = error;
                _responseobject = responseObject;
                _blockFinished = YES;
                _task = task;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error should] beNil];
            [[_task.currentRequest.HTTPMethod should] equal:@"GET"];
            [[_task.currentRequest.URL should] equal:url];
            [[_task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
            [[_responseobject should] beNonNil];
        });
    });
    
});

SPEC_END
