//
//  DataObjectManipulationsSpec.m
//  syncano-ios
//
//  Created by Jakub Machoń on 04.02.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "Book.h"

#define TestNeedsToWaitForBlock() __block BOOL blockFinished = NO
#define BlockFinished() blockFinished = YES
#define WaitForBlock() while (CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true) && !blockFinished)

SPEC_BEGIN(DataObjectManipulationsSpec)

describe(@"Data object manipulations", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    
    __block Book* book;
    beforeAll(^{
        __block BOOL _blockFinished;
        __block NSError *_error;
        [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _blockFinished = YES;
            book = objects.firstObject;
            _error = error;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
        [[_error should] beNil];
        [[book should] beNonNil];
    });
    
    context(@"Changing values", ^{
        
        it(@"should increment one value", ^{
            __block BOOL _blockFinished;
            __block NSError *_error;
            NSNumber* expectedLoversNb = @(book.lovers.integerValue + 1);
            [book incrementKey:@"lovers" by:@(1) withCompletion:^(NSError *error) {
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            [[book.lovers should] equal:expectedLoversNb];
            
        });
        
        it(@"should increment many values", ^{
            __block BOOL _blockFinished;
            __block NSError *_error;
            NSNumber* expectedLoversNb = @(book.lovers.integerValue - 1);
            NSNumber* expectedReadersNb = @(book.readers.integerValue + 12);
            [book incrementValues:@{@"lovers":@(-1),@"readers":@12} withCompletion:^(NSError *error) {
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            [[book.lovers should] equal:expectedLoversNb];
            [[book.readers should] equal:expectedReadersNb];
        });
    });
    
    context(@"Errors", ^{
        it(@"should error on unknown property", ^{
            __block BOOL _blockFinished;
            __block NSError *_error;
            [book incrementKey:@"haters" by:@1 withCompletion:^(NSError *error) {
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNonNil];
            [[_error.domain should] equal:SCDataObjectErrorDomain];
            [[theValue(_error.code) should] equal:theValue(SCErrorCodeDataObjectNonExistingPropertyName)];
            
        });
        
        it(@"should behave nicely when called on nonsaved object", ^{
            __block BOOL _blockFinished;
            __block NSError *_error;
            Book* newBook = [[Book alloc] init];
            [newBook incrementKey:@"lovers" by:@1 withCompletion:^(NSError *error) {
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNonNil];
            
        });
    });
    
});

SPEC_END
