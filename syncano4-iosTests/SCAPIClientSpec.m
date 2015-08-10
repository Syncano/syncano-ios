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
        
        it(@"should set social auth key", ^{
            SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
            [apiClient setSocialAuthTokenKey:@"SOCIAL-AUTH-TOKEN-KEY"];
            [[apiClient.requestSerializer.HTTPRequestHeaders[@"Authorization"] should] equal:@"token SOCIAL-AUTH-TOKEN-KEY"];
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
                NSURLSessionDataTask *task = [apiClient getTaskWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[task.currentRequest.HTTPMethod should] equal:@"GET"];
                [[task.currentRequest.URL should] equal:url];
                [[task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
            });
            it(@"should create, authorize and call POST task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                NSURLSessionDataTask *task = [apiClient postTaskWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[task.currentRequest.HTTPMethod should] equal:@"POST"];
                [[task.currentRequest.URL should] equal:url];
                [[task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
                NSData *httpBody = [NSJSONSerialization dataWithJSONObject:@{@"param" : @"value"} options:0 error:nil];
                [[task.originalRequest.HTTPBody should] equal:httpBody];
            });
            
            it(@"should create, authorize and call PUT task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                NSURLSessionDataTask *task = [apiClient putTaskWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[task.currentRequest.HTTPMethod should] equal:@"PUT"];
                [[task.currentRequest.URL should] equal:url];
                [[task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
                NSData *httpBody = [NSJSONSerialization dataWithJSONObject:@{@"param" : @"value"} options:0 error:nil];
                [[task.originalRequest.HTTPBody should] equal:httpBody];
            });
            
            it(@"should create, authorize and call PATCH task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                NSURLSessionDataTask *task = [apiClient patchTaskWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[task.currentRequest.HTTPMethod should] equal:@"PATCH"];
                [[task.currentRequest.URL should] equal:url];
                [[task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
                
                NSData *httpBody = [NSJSONSerialization dataWithJSONObject:@{@"param" : @"value"} options:0 error:nil];
                [[task.originalRequest.HTTPBody should] equal:httpBody];
            });
            
            it(@"should create, authorize and call DELETE task", ^{
                SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/PATH?param=value",kBaseURL]];
                __block NSError *_error;
                __block BOOL _blockFinished;
                NSURLSessionDataTask *task = [apiClient deleteTaskWithPath:@"PATH" params:@{@"param" : @"value"} completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    _error = error;
                    _blockFinished = YES;
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[apiClient.requestSerializer.HTTPRequestHeaders[@"X-API-KEY"] should] equal:@"API-KEY"];
                [[task.currentRequest.HTTPMethod should] equal:@"DELETE"];
                [[task.currentRequest.URL should] equal:url];
                [[task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
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
            [[_error shouldEventually] beNil];
            
            NSData *reference = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"syncano-white" ofType:@"png"]];
            
            [[_responseobject shouldEventually] beKindOfClass:[NSData class]];
            [[_responseobject shouldEventually] equal:reference];
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
            SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/classes/book/objects/",kBaseURL]];
            NSURLSessionDataTask *task = [apiClient getDataObjectsFromClassName:@"book" params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                _error = error;
                _responseobject = responseObject;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[task.currentRequest.HTTPMethod should] equal:@"GET"];
            [[task.currentRequest.URL should] equal:url];
            [[task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
            [[_responseobject[@"objects"] shouldEventually] beKindOfClass:[NSArray class]];
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
            SCAPIClient *apiClient = [SCAPIClient apiClientForSyncano:syncano];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@INSTANCE-NAME/classes/book/objects/2/",kBaseURL]];
            NSURLSessionDataTask *task = [apiClient getDataObjectsFromClassName:@"book" withId:@2 completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                _error = error;
                _responseobject = responseObject;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[task.currentRequest.HTTPMethod should] equal:@"GET"];
            [[task.currentRequest.URL should] equal:url];
            [[task.currentRequest.allHTTPHeaderFields[@"X-API-KEY"] should] equal:@"API-KEY"];
            [[_responseobject shouldEventually] beNonNil];
        });
    });
    
});

SPEC_END
