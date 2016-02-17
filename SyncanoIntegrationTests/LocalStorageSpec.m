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

SPEC_BEGIN(LocalStorageSpec)

describe(@"LocalStorageSpec", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apikey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [SCFileManager cleanUpLocalStorage];
        [Syncano enableOfflineStorage];
        [Syncano sharedInstanceWithApiKey:apikey instanceName:instanceName];

    });
    
    context(@"data object", ^{
        __block Book *_book;
        it(@"should save data object locally", ^{
            __block NSError *_error;
            __block BOOL _blockFinished;
           
            __block Book *_storedBook;
            __block NSNumber *_bookId;
            __block NSString *_bookTitle;
            __block NSNumber *_bookNumOfPages;
            
            //Getting books from API
            [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                _book = [objects firstObject];
                _bookId = _book.objectId;
                _bookTitle = _book.title;
                _bookNumOfPages = _book.numOfPages;
                // Savig first of them
                [_book saveToLocalStorageWithCompletion:^(NSError *error) {
                    SCPredicate *predicate = [SCPredicate whereKey:@"objectId" isEqualToNumber:_bookId];
                   // Getting this book from local storage
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
            [[_error should] beNil];
            [[_book should] beNonNil];
            [[_storedBook should] beNonNil];
            [[_bookId should] equal:_storedBook.objectId];
            [[_bookTitle should] equal:_storedBook.title];
            [[_bookNumOfPages should] equal:_storedBook.numOfPages];


        });
        
        it(@"should delete that object", ^{
            __block NSError *_fetchError;
            __block NSError *_saveError;
            __block NSError *_deleteError;
            
            __block BOOL _blockFinished;
            __block Book *_book;
            __block Book *_storedBook;
            __block NSNumber *_bookId;

            
            //Getting books from API
            [[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                _fetchError = error;
                _book = [objects firstObject];
                _bookId = _book.objectId;
                // Savig first of them
                [_book saveToLocalStorageWithCompletion:^(NSError *error) {
                    _saveError = error;
                    if(error){
                        NSLog(@"error: %@",error);
                    }
                    
                    [_book deleteFromLocalStorageWithCompletion:^(NSError *error) {
                        _deleteError = error;
                        // Getting this book from local storage
                        SCPredicate *predicate = [SCPredicate whereKey:@"objectId" isEqualToNumber:_bookId];
                        [[Book please] giveMeDataObjectsFromLocalStorageWithPredicate:predicate completion:^(NSArray *objects, NSError *error) {
                            _storedBook = [objects firstObject];
                            _blockFinished = YES;
                        }];
                    }];
                }];
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_fetchError should] beNil];
            [[_saveError should] beNil];
            [[_deleteError should] beNil];
            [[_book should] beNonNil];
            [[_storedBook should] beNil];
        });
    });
    
    context(@"local search", ^{
        
        const NSString* const bookTitle = @"Karius og Baktus";
        __block Book* newBook = [[Book alloc] init];
        
        void (^testBook)(SCPredicate*,BOOL) = ^(SCPredicate* predicate, BOOL shouldFindBook) {
            __block NSError *_error;
            __block BOOL _blockFinished;
            __block Book *_storedBook;
            
            [[Book please] giveMeDataObjectsFromLocalStorageWithPredicate:predicate completion:^(NSArray *objects, NSError *error) {
                _storedBook = [objects firstObject];
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error should] beNil];
            if(shouldFindBook) {
                [[_storedBook should] beNonNil];
                [[_storedBook.title should] equal:bookTitle];
            } else {
                [[_storedBook should] beNil];
            }
        };
        
        beforeAll(^{
            __block NSError* _error;
            __block BOOL _blockFinished;
            newBook = [[Book alloc] init];
            newBook.title = [bookTitle copy];
            newBook.numOfPages = @(23);
            [newBook saveToLocalStorageWithCompletion:^(NSError *error) {
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error should] beNil];
        });
        
        afterAll(^{
            __block NSError* _error;
            __block BOOL _blockFinished;
            [newBook deleteFromLocalStorageWithCompletion:^(NSError *error) {
                _blockFinished = YES;
                _error = error;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error should] beNil];
        });
        
        it(@"should work for hasPrefix", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" hasPrefix:@"Karius"];
            testBook(predicate, YES);
        });
        it(@"should work for hasPrefix case sensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" hasPrefix:@"karius"];
            testBook(predicate, NO);
        });
        it(@"should work for hasPrefix case insensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" caseInsensitiveHasPrefix:@"karius"];
            testBook(predicate, YES);
        });
        
        it(@"should work for hasSuffix", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" hasSuffix:@"Baktus"];
            testBook(predicate, YES);
        });
        it(@"should work for hasSuffix case sensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" hasSuffix:@"baktus"];
            testBook(predicate, NO);
        });
        it(@"should work for hasSuffix case insensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" caseInsensitiveHasSuffix:@"baktus"];
            testBook(predicate, YES);
        });
        
        it(@"should work for contains", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" containsString:@"s og B"];
            testBook(predicate, YES);
        });
        it(@"should work for contains case sensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" containsString:@"s og b"];
            testBook(predicate, NO);
        });
        it(@"should work for contains case insensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" caseInsensitiveContainsString:@"s og b"];
            testBook(predicate, YES);
        });
        
        it(@"should work for equals", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" isEqualToString:@"Karius og Baktus"];
            testBook(predicate, YES);
        });
        it(@"should work for equals case sensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" isEqualToString:@"karius og baktus"];
            testBook(predicate, NO);
        });
        it(@"should work for equals case insensitive", ^{
            SCPredicate *predicate = [SCPredicate whereKey:@"title" caseInsensitiveIsEqualToString:@"karius og baktus"];
            testBook(predicate, YES);
        });
    });
});

SPEC_END
