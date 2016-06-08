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
#import "BookStore.h"

SPEC_BEGIN(DataObjectDataTypesSpec)

describe(@"DataObjectDataTypesSpec", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    });

    context(@"data object", ^{
        
        context(@"object", ^{
            it(@"should serialize object data type to NSDictionary", ^{
                
                __block BOOL _blockFinished = NO;
                __block NSError *_fetchError;
                __block Book *_book;
                
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
        });
        
        context(@"array", ^{
            it(@"should serialize array data type to NSArray", ^{
                __block BOOL _blockFinished = NO;
                __block NSError *_fetchError;
                __block Book *_book;
                
                SCPredicate *predicate = [SCPredicate whereKey:@"id" isEqualToNumber:@272];
                [[Book please] giveMeDataObjectsWithPredicate:predicate parameters:@{SCPleaseParameterPageSize : @1} completion:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    _blockFinished = YES;
                    _fetchError = error;
                    _book = (Book *)[objects firstObject];
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
                [[_fetchError should] beNil];
                [[_book shouldNot] beNil];
                [[_book.pages should] beKindOfClass:[NSArray class]];
            });
            
            it(@"should rise an error while adding not supported data type into array", ^{
                
                __block BOOL _blockFinished = NO;
                __block NSError *_saveError;
                __block Book *_book;
                
                NSDictionary *pageOne = @{@"name" : @"page one"};
                
                _book = [Book new];
                _book.title = @"World in an array";
                _book.pages = @[pageOne];
                [_book saveWithCompletionBlock:^(NSError * _Nullable error) {
                    _blockFinished = YES;
                    _saveError = error;
                }];
                
                [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
                [[_saveError shouldNot] beNil]; //Array can only contain strings, booleans, integers and floats.
            });
        });
        
        context(@"geopoint", ^{
            it(@"should serialize geopoint data type to SCGeoPoint instance", ^{
                __block BOOL _blockFinished = NO;
                __block NSError *_fetchError;
                __block BookStore *_bookStore;
                
                [[BookStore please] giveMeDataObjectsWithCompletion:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    _blockFinished = YES;
                    _fetchError = error;
                    _bookStore = (BookStore *)[objects firstObject];
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
                [[_fetchError should] beNil];
                [[_bookStore shouldNot] beNil];
                [[_bookStore.location should] beKindOfClass:[SCGeoPoint class]];
                [[theValue(_bookStore.location.longitude) shouldNot] beNil];
                [[theValue(_bookStore.location.latitude) shouldNot] beNil];
            });

        });


    });
});

SPEC_END
