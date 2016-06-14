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

SPEC_BEGIN(DataObjectArrayOperatorsSpec)

describe(@"Data object array operators", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    __block Book* book;
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
        
        __block BOOL _blockFinished = NO;
        __block NSError *_error;
        SCPredicate *predicate = [SCPredicate whereKey:@"id" isEqualToNumber:@272];
        [[Book please] giveMeDataObjectsWithPredicate:predicate parameters:@{SCPleaseParameterPageSize : @1} completion:^(NSArray *objects, NSError *error) {
            _blockFinished = YES;
            book = objects.firstObject;
            _error = error;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
        [[_error should] beNil];
        [[book should] beNonNil];
    });
    
    context(@"Changing values", ^{
        
        it(@"should add array objects", ^{
            __block BOOL _blockFinished = NO;
            __block NSError *_error;
            //NSNumber* expectedLoversNb = @(book.lovers.integerValue + 1);
            [book addArrayOfObjects:@[@"nextPage"] forArrayWithKey:@"pages" withCompletion:^(NSError * _Nullable error) {
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            [[book.pages should] contain:@"nextPage"];
            
        });
        
        it(@"should remove array objects", ^{
            __block BOOL _blockFinished = NO;
            __block NSError *_error;
            //NSNumber* expectedLoversNb = @(book.lovers.integerValue + 1);
            [book addArrayOfObjects:@[@"pageToRemove"] forArrayWithKey:@"pages" withCompletion:^(NSError * _Nullable error) {
                [book removeArrayOfObjects:@[@"pageToRemove"] fromArrayWithKey:@"pages" withCompletion:^(NSError * _Nullable error) {
                    _blockFinished = YES;
                    _error = error;
                }];
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            [[book.pages shouldNot] contain:@"pageToRemove"];
            
        });
        
    });
    
});

SPEC_END
