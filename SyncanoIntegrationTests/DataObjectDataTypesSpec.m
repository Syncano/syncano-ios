//
//  OfflineStorageSpec.m
//  syncano-ios
//
//  Created by Jan Lipmann on 22/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "SCFileManager.h"
#import "Book.h"

SPEC_BEGIN(DataObjectDataTypesSpec)

describe(@"DataObjectDataTypesSpec", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    });

    context(@"data object", ^{
        
        __block BOOL _blockFinished = NO;
        __block NSError *_fetchError;
        __block Book *_book;
        
        it(@"should render object data type to NSDictionary", ^{
           
            SCPredicate *predicate = [SCPredicate whereKey:@"id" isEqualToNumber:@272];
            [[Book please] giveMeDataObjectsWithPredicate:predicate parameters:@{SCPleaseParameterPageSize : @1} completion:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                _blockFinished = YES;
                _fetchError = error;
                _book = (Book *)[objects firstObject];
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_fetchError should] beNil];
            [[_book shouldNot] beNil];
            [[_book.metadata should] beKindOfClass:[NSDictionary class]];
            [[[_book.metadata objectForKey:@"name"] should] equal:@"test"];
        });
        
        it(@"should render array data type to NSArray", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"id" isEqualToNumber:@272];
            [[Book please] giveMeDataObjectsWithPredicate:predicate parameters:@{SCPleaseParameterPageSize : @1} completion:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                _blockFinished = YES;
                _fetchError = error;
                _book = (Book *)[objects firstObject];
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_book shouldNot] beNil];
            [[_book.pages should] beKindOfClass:[NSArray class]];
        });

    });
});

SPEC_END
