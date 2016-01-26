//
//  OfflineStorageSpec.m
//  syncano-ios
//
//  Created by Jan Lipmann on 22/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "Book.h"

SPEC_BEGIN(OfflineStorage)

describe(@"OfflineStorage", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apikey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano enableOfflineStorage];
        [Syncano sharedInstanceWithApiKey:apikey instanceName:instanceName];

    });
    
    context(@"save data object", ^{
        it(@"should save data object locally", ^{
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block Book *_book;
            __block NSNumber *_bookId;
            __block Book *_storedBook;
            [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                _book = [objects firstObject];
                _bookId = _book.objectId;
                [_book saveToLocalStorageWithCompletion:^(NSError *error) {
                    SCPredicate *predicate = [SCPredicate whereKey:@"objectId" isEqualToNumber:_bookId];
                    [[Book please] giveMeDataObjectsFromLocalStorageWithPredicate:predicate completion:^(NSArray *objects, NSError *error) {
                        _storedBook = [objects firstObject];
                    }];
                    _blockFinished = YES;
                    _error = error;
                    if(error){
                        NSLog(@"error: %@",error);
                    }
                }];
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error shouldEventually] beNil];
            [[_book shouldEventually] beNonNil];
            [[_storedBook shouldEventually] beNonNil];
            [[_bookId shouldEventually] equal:_storedBook.objectId];
        });
    });
    
});

SPEC_END
