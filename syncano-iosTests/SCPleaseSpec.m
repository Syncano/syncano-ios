//
//  SCDataObjectSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "SCPredicate.h"
#import "Book.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

SPEC_BEGIN(SCPleaseSpec)

describe(@"SCPlease", ^{
    
    it(@"should init witha Data Object class", ^{
        SCPlease *please = [[SCPlease alloc] initWithDataObjectClass:[Book class]];
        [[please should] beNonNil];
    });
    
    it(@"should create new SCPlease object for provided class", ^{
        SCPlease *please = [SCPlease pleaseInstanceForDataObjectWithClass:[Book class]];
        [[please should] beNonNil];

    });
    
    it(@"should create new SCPlease object for provided class for provided Syncano instance", ^{
        Syncano *syncano = [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        SCPlease *please = [SCPlease pleaseInstanceForDataObjectWithClass:[Book class] forSyncano:syncano];
        [[please should] beNonNil];
        [[please.syncano should] equal:syncano];
        
    });
    
    it(@"should create new SCPlease object for User class", ^{
        SCPlease *please = [SCPlease pleaseInstanceForUserClass];
        [[please should] beNonNil];
        
    });
    
    it(@"should create new SCPlease object for User class for provided Syncano instance", ^{
        Syncano *syncano = [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        SCPlease *please = [SCPlease pleaseInstanceForUserClassForSyncano:syncano];
        [[please should] beNonNil];
        [[please.syncano should] equal:syncano];
        
    });
    
    it(@"should fetch objects from API", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *books;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            books = objects;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[books shouldNotEventually] beNil];
        [[[books firstObject] shouldEventually] beKindOfClass:[Book class]];
    });
    
#warning TODO: we have to test cases with wrong parameters
    
    it(@"should fetch objects from API with parameters", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *books;
        __block NSError *_error;
        __block BOOL _blockFinished;
        NSDictionary *parameters = @{SCPleaseParameterIncludeKeys : @[@"author"]};
        [[Book please] giveMeDataObjectsWithParameters:parameters completion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            books = objects;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[books shouldNotEventually] beNil];
        [[[books firstObject] shouldEventually] beKindOfClass:[Book class]];
    });
    
    it(@"should fetch objects from API with predicate and parameters", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *books;
        __block NSError *_error;
        __block BOOL _blockFinished;
        NSDictionary *parameters = @{SCPleaseParameterIncludeKeys : @[@"author"]};
        SCPredicate *predicate = [SCPredicate whereKey:@"numofpages" isEqualToNumber:@123];
        [[Book please] giveMeDataObjectsWithPredicate:predicate parameters:parameters completion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            books = objects;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[books shouldNotEventually] beNil];
        [[[books firstObject] shouldEventually] beKindOfClass:[Book class]];
    });
    
    it(@"should fetch next page of objects from API", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *books;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [[Book please] giveMeNextPageOfDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            books = objects;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[books shouldNotEventually] beNil];
        [[[books firstObject] shouldEventually] beKindOfClass:[Book class]];
    });
    
    it(@"should fetch previous page of objects from API", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *books;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [[Book please] giveMePreviousPageOfDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            books = objects;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[books shouldNotEventually] beNil];
        [[[books firstObject] shouldEventually] beKindOfClass:[Book class]];
    });
    
});

SPEC_END
