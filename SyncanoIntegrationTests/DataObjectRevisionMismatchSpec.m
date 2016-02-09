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
    NSString *apikey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apikey instanceName:instanceName];
    });
    
    context(@"data object revision check", ^{
        
        it(@"should rise mismatch error", ^{
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block BOOL _mismatched;
            __block NSString *_mismatchDescription;

            //Getting books from API
            [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                Book *_book = [objects firstObject];
                // Savig first of them
                
                _book.revision = @(_book.revision.integerValue - 1);
                
                [_book saveWithCompletionBlock:^(NSError *error) {
                    _error = error;
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
            [[_error should] beNonNil];
            [[theValue(_mismatched) should] beYes];
            [[_mismatchDescription should] beNonNil];

        });
        it(@"should pass", ^{
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block BOOL _mismatched;
            __block NSString *_mismatchDescription;
            
            //Getting books from API
            [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                Book *_book = [objects firstObject];

                [_book saveWithCompletionBlock:^(NSError *error) {
                    _error = error;
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
            [[_error should] beNil];
            [[theValue(_mismatched) should] beNo];
            [[_mismatchDescription should] beNil];
        });

    });
    
});

SPEC_END
