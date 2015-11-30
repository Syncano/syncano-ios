//
//  SCDataObjectSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "Book.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHPathHelpers.h"


SPEC_BEGIN(SCDataObjectSpec)

describe(@"SCDataObject", ^{
    
    it(@"should generate class name for API calls", ^{
        [[[Book classNameForAPI] should] equal:@"book"];
    });
    
    it(@"should create properties map", ^{
        NSSet *propsMap = [SCDataObject propertyKeys];
        [[propsMap should] beNonNil];
        [[propsMap should] beKindOfClass:[NSSet class]];
    });
    
    it(@"should register class", ^{
        [Book registerClass];
        SCClassRegisterItem *registerOfClass = [[SCParseManager sharedSCParseManager] registeredItemForClass:[Book class]];
        [[registerOfClass shouldNot] beNil];
    });
    
    it(@"should merge keys", ^{
        SCDataObject *dataObjectMock = [SCDataObject new];
        dataObjectMock.objectId = @1222;
        NSDictionary *serializedObject = [MTLJSONAdapter JSONDictionaryFromModel:dataObjectMock error:nil];
        [[serializedObject[@"id"] should] equal:@1222];
    });
    
    context(@"singleton syncano instance", ^{
        
        beforeAll(^{
            [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        });
        
        it(@"should save object", ^{
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Book.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block Book *book = [Book new];
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book saveWithCompletionBlock:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[book.objectId shouldEventually] beNonNil];
        });
        
        it(@"should fetch object", ^{
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Book.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block Book *book = [Book new];
            book.objectId = @2;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book fetchWithCompletion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[book.objectId shouldEventually] equal:@2];
            [[book.numOfPages shouldEventually] equal:@123];
            [[book.title shouldEventually] equal:@"googlebook"];
        });
        
        it(@"should delete object on server", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithData:[NSData new]
                                                  statusCode:204
                                                     headers:@{@"Content-Type":@"application/json"}];
            }];
            
            Book *book = [Book new];
            book.objectId = @2;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book deleteWithCompletion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
        });
        
        it(@"should update value for provided key", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Book.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            Book *book = [Book new];
            book.objectId = @2;
            book.title = @"ORIGINAL-TITLE";
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book updateValue:@"NEW-TITLE" forKey:@"title" withCompletion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[book.title shouldEventually] equal:@"NEW-TITLE"];
        });
    
    });
    
    context(@"custom syncano instance", ^{
        Syncano *syncano = [[Syncano alloc] initWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        it(@"should save object", ^{
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Book.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block Book *book = [Book new];
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book saveToSyncano:syncano withCompletion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[book.objectId shouldEventually] beNonNil];
        });
        
        it(@"should fetch object", ^{
            
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Book.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            __block Book *book = [Book new];
            book.objectId = @2;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book fetchFromSyncano:syncano completion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[book.objectId shouldEventually] equal:@2];
            [[book.numOfPages shouldEventually] equal:@123];
            [[book.title shouldEventually] equal:@"googlebook"];
        });
        
        it(@"should delete object on server", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithData:[NSData new]
                                                  statusCode:204
                                                     headers:@{@"Content-Type":@"application/json"}];
            }];
            
            Book *book = [Book new];
            book.objectId = @2;
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book deleteFromSyncano:syncano completion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
        });
        
        it(@"should update value for provided key", ^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Book.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
            
            Book *book = [Book new];
            book.objectId = @2;
            book.title = @"ORIGINAL-TITLE";
            __block NSError *_error;
            __block BOOL _blockFinished;
            [book updateValue:@"NEW-TITLE" forKey:@"title" inSyncano:syncano withCompletion:^(NSError *error) {
                _error = error;
                _blockFinished = YES;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[book.title shouldEventually] equal:@"NEW-TITLE"];
        });
        
    });
});

SPEC_END
