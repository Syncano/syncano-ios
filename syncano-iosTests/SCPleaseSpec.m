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
#import "OHPathHelpers.h"


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
        NSDictionary *parameters = @{SCPleaseParameterPageSize : @12 , SCPleaseParameterIncludeCount : @YES};
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
        NSDictionary *parameters = @{SCPleaseParameterPageSize : @12};
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
    
    it(@"should have next page of objects from API", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *books;
        __block NSError *_error;
        __block BOOL _blockFinished = NO;
         SCPlease *please = [Book please];
        __block NSString *nextString;
        [please giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            books = objects;
            nextString = [please valueForKey:@"nextUrlString"];
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[books shouldNotEventually] beNil];
        [[[books firstObject] shouldEventually] beKindOfClass:[Book class]];
        [[nextString shouldNot] beNil];
        [[nextString should] equal:@"/v1.1/instances/mytestinstance/classes/book/objects/?direction=1"];
    });
    
    it(@"should have previous page of objects from API", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Books.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *books;
        __block NSError *_error;
        __block BOOL _blockFinished;
        SCPlease *please = [Book please];
        __block NSString *prevString;
        [please giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            books = objects;
            prevString = [please valueForKey:@"previousUrlString"];
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[books shouldNotEventually] beNil];
        [[[books firstObject] shouldEventually] beKindOfClass:[Book class]];
        [[prevString shouldNot] beNil];
        [[prevString should] equal:@"/v1.1/instances/mytestinstance/classes/book/objects/?direction=0"];
    });
    
});

SPEC_END
