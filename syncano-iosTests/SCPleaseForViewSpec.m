//
//  SCPleaseForViewSpec.m
//  syncano-ios
//
//  Created by Jakub Machoń on 25.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "SCPredicate.h"
#import "Message.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHPathHelpers.h"
#import "SCPleaseForView.h"

SPEC_BEGIN(SCPleaseForViewSpec)

describe(@"SCPleaseForView", ^{
    
    it(@"should init with a Data Object class", ^{
        SCPleaseForView *please = [[SCPleaseForView alloc] initWithDataObjectClass:[Message class]];
        [[please should] beNonNil];
    });
    
    it(@"should create new SCPleaseForView object for provided class", ^{
        SCPlease *please = [SCPleaseForView pleaseInstanceForDataObjectWithClass:[Message class] forView:@"test_view"];
        [[please should] beNonNil];
        [[please should] beKindOfClass:[SCPleaseForView class]];
    });
    
    it(@"should create new SCPleaseForView object for provided class for provided Syncano instance", ^{
        Syncano *syncano = [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        SCPlease *please = [SCPleaseForView pleaseInstanceForDataObjectWithClass:[Message class] forView:@"test_view" forSyncano:syncano];
        [[please should] beNonNil];
        [[please.syncano should] equal:syncano];
        [[please should] beKindOfClass:[SCPleaseForView class]];
        
    });
    
    it(@"should fetch objects from API", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [[request.URL absoluteString] isEqualToString:@"https://api.syncano.io/v1/instances/INSTANCE-NAME/api/objects/test_view/get/?"];
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"ViewResponse.json",self.class)
                                                    statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        }];
        __block NSArray *messages;
        __block NSError *_error;
        __block BOOL _blockFinished;
        [[Message pleaseForView:@"test_view"] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _error = error;
            _blockFinished = YES;
            messages = objects;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[_error should] beNil];
        [[messages shouldNot] beNil];
        [[[messages firstObject] should] beKindOfClass:[Message class]];
    });
    
});

SPEC_END

