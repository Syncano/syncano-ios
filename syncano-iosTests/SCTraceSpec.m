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
#import "SCJSONHelper.h"


SPEC_BEGIN(SCTraceSpec)

describe(@"SCTrace", ^{
    
    
    it(@"CodeBox Trace should init with JSON object and codebox identifier", ^{
        id JSONObject = [SCJSONHelper JSONObjectFromFileWithName:@"Trace"];
        SCTrace *trace = [[SCTrace alloc] initWithJSONObject:JSONObject andCodeboxIdentifier:@123];
        [[trace should] beNonNil];
        [[trace.identifier  should] equal:@45];
        [[trace.codeboxIdentifier should] equal:@123];
    });
    
    it(@"Script Trace should init with JSON object and script identifier", ^{
        id JSONObject = [SCJSONHelper JSONObjectFromFileWithName:@"Trace-Script"];
        SCTrace *trace = [[SCTrace alloc] initWithJSONObject:JSONObject andScriptIdentifier:@123];
        [[trace should] beNonNil];
        [[trace.identifier  should] equal:@45];
        [[trace.scriptIdentifier should] equal:@123];
    });
    
    it(@"should fetch CodeBox race from singleton Syncano instance", ^{
        [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        id JSONObject = [SCJSONHelper JSONObjectFromFileWithName:@"Trace"];
        SCTrace *codeboxTrace = [[SCTrace alloc] initWithJSONObject:JSONObject andCodeboxIdentifier:@123];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block SCTrace *_trace;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [codeboxTrace fetchWithCompletion:^(SCTrace *trace, NSError *error) {
            _trace = trace;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_trace shouldEventually] beNonNil];
    });
    
    it(@"should fetch Script Trace from singleton Syncano instance", ^{
        [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        id JSONObject = [SCJSONHelper JSONObjectFromFileWithName:@"Trace"];
        SCTrace *scriptTrace = [[SCTrace alloc] initWithJSONObject:JSONObject andScriptIdentifier:@123];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace-Script.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block SCTrace *_trace;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [scriptTrace fetchWithCompletion:^(SCTrace *trace, NSError *error) {
            _trace = trace;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_trace shouldEventually] beNonNil];
    });
    
    it(@"should fetch CodeBox Trace from provided Syncano instance", ^{
       Syncano *syncano =  [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        id JSONObject = [SCJSONHelper JSONObjectFromFileWithName:@"Trace"];
        SCTrace *codeboxTrace = [[SCTrace alloc] initWithJSONObject:JSONObject andCodeboxIdentifier:@123];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block SCTrace *_trace;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [codeboxTrace fetchFromSyncano:syncano withCompletion:^(SCTrace *trace, NSError *error) {
            _trace = trace;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_trace shouldEventually] beNonNil];
    });
    
    it(@"should fetch Script Trace from provided Syncano instance", ^{
        Syncano *syncano =  [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        id JSONObject = [SCJSONHelper JSONObjectFromFileWithName:@"Trace"];
        SCTrace *scriptTrace = [[SCTrace alloc] initWithJSONObject:JSONObject andScriptIdentifier:@123];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"Trace-Script.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        
        __block SCTrace *_trace;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [scriptTrace fetchFromSyncano:syncano withCompletion:^(SCTrace *trace, NSError *error) {
            _trace = trace;
            _error = error;
            _blockFinished = YES;
        }];
        
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error shouldEventually] beNil];
        [[_trace shouldEventually] beNonNil];
    });
});

SPEC_END
