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

SPEC_BEGIN(DataObjectRevisionMismatch)

describe(@"DataObjectRevisionMismatch", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    });
    
    context(@"data object revision check", ^{
        
        it(@"should rise mismatch error", ^{
            __block Book *_book;
            __block NSError *_fetchError;
            __block NSError *_saveError;
            __block BOOL _blockFinished = NO;
            __block BOOL _mismatched;
            __block NSString *_mismatchDescription;

            [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                _fetchError = error;

                _book = [objects firstObject];
                _book.revision = @(_book.revision.integerValue - 1);
                
                [_book saveWithCompletionBlock:^(NSError *error) {
                    _saveError = error;
                    if(error){
                        NSLog(@"error: %@",error);
                    }
                } revisionMismatchValidationBlock:^(BOOL mismatched, NSString *description) {
                    _blockFinished = YES;
                    _mismatched = mismatched;
                    _mismatchDescription = description;
                }];
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_fetchError should] beNil];
            [[_book should] beNonNil];
            [[_saveError should] beNonNil];
            [[theValue(_mismatched) should] beYes];
            [[_mismatchDescription should] beNonNil];

        });
        it(@"should pass", ^{
            __block Book *_book;
            __block NSError *_fetchError;
            __block NSError *_saveError;
            __block BOOL _blockFinished = NO;
            __block BOOL _mismatched;
            __block NSString *_mismatchDescription;
            
            
            [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                _fetchError = error;
                _book = [objects firstObject];
                [_book saveWithCompletionBlock:^(NSError *error) {
                    _saveError = error;
                    if(error){
                        NSLog(@"error: %@",error);
                    }
                } revisionMismatchValidationBlock:^(BOOL mismatched, NSString *description) {
                    _blockFinished = YES;
                    _mismatched = mismatched;
                    _mismatchDescription = description;
                }];
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_fetchError should] beNil];
            [[_book should] beNonNil];
            [[_saveError should] beNil];
            [[theValue(_mismatched) should] beNo];
            [[_mismatchDescription should] beNil];
        });

    });
    
});

SPEC_END
