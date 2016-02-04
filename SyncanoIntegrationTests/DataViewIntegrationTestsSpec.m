//
//  DataViewIntegrationTestsSpec.m
//  syncano-ios
//
//  Created by Jakub Machoń on 02.02.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "Book.h"

SPEC_BEGIN(DataViewIntegrationTestsSpec)

describe(@"Data views", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    
    [Book registerClass];
    [Author registerClass];
    
    context(@"Fetch data from view", ^{
        
        __block NSError *_error;
        __block BOOL _blockFinished;
        __block NSArray* _books;
        [[Book pleaseForView:@"books_with_authors"] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
            _blockFinished = YES;
            _books = objects;
            _error = error;
        }];
        
        it(@"should return books and authors and have \"Aquarium\" book by Viktor Suvorov", ^{
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            [[_books should] beNonNil];

            Book* firstBook = [_books firstObject];
            [[firstBook should] beKindOfClass:[Book class]];
            [[firstBook.author should] beKindOfClass:[Author class]];

            NSArray* filteredBooks = [_books filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title = %@",@"Aquarium"]];
            [[filteredBooks should] haveCountOf:1];
            Book* book = filteredBooks.firstObject;
            [[book.title should] equal:@"Aquarium"];
            [[book.numOfPages should] equal:@(249)];
            [[book.author.name should] equal:@"Viktor"];
            [[book.author.surname should] equal:@"Suvorov"];
        });
    });
    
    context(@"Fetch data from view with query", ^{
        
        __block NSError *_error;
        __block BOOL _blockFinished;
        __block NSArray* _books;
        [[Book pleaseForView:@"books_with_authors"] giveMeDataObjectsWithPredicate:[SCPredicate whereKey:@"numofpages" isEqualToNumber:@(288)] parameters:nil completion:^(NSArray *objects, NSError *error) {
            _blockFinished = YES;
            _books = objects;
            _error = error;
        }];
        
        it(@"should return Saab 9-3 manual by Saab Automobile AB", ^{
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            [[_books should] beNonNil];
            
            [[_books should] haveCountOf:1];
            
            Book* book = [_books firstObject];
            [[book.title should] equal:@"Saab 9-3 MY 2004 owners manual"];
            [[book.numOfPages should] equal:@(288)];
            [[book.author.name should] beNil];
            [[book.author.surname should] equal:@"Saab Automobile AB"];
        });
    });
    
    context(@"Fetch data from view with join query", ^{
        
        __block NSError *_error;
        __block BOOL _blockFinished;
        __block NSArray* _books;
        [[Book pleaseForView:@"books_with_authors"] giveMeDataObjectsWithPredicate:
         [SCPredicate whereKey:@"author" satisfiesPredicate:
          [SCCompoundPredicate compoundPredicateWithPredicates:@[[SCPredicate whereKey:@"name" isEqualToString:@"Viktor"],
                                                                 [SCPredicate whereKey:@"surname" isEqualToString:@"Suvorov"]]]]
                    parameters:nil completion:^(NSArray *objects, NSError *error) {
            _blockFinished = YES;
            _books = objects;
            _error = error;
        }];
        
        it(@"should return books by Viktor Suvorov", ^{
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_error should] beNil];
            [[_books should] beNonNil];
            
            [[_books should] haveCountOf:2];
            
            //Book* bookOne = [_books firstObject];
            Book* bookTwo = [_books lastObject];
            //[[bookOne.author should] beIdenticalTo:bookTwo.author];
            [[bookTwo.author.name should] equal:@"Viktor"];
            [[bookTwo.author.surname should] equal:@"Suvorov"];
        });
    });
    
    context(@"Fetch data from pages", ^{
        
        SCPlease* please = [Book pleaseForView:@"books_with_authors"];
        
        __block NSError *_error;
        __block BOOL _blockFinished;
        __block NSArray* _books;
        __block NSArray* _booksNextPage;
        __block NSArray* _booksPrevPage;
        [please giveMeDataObjectsWithPredicate:nil parameters:@{SCPleaseParameterPageSize:@(2)} completion:^(NSArray *objects, NSError *error) {
            _books = objects;
            _error = error;
            if(error) {
                _blockFinished = YES;
                return;
            }
            sleep(2);
            [please giveMeNextPageOfDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                _booksNextPage = objects;
                _error = error;
                if(error) {
                    _blockFinished = YES;
                    return;
                }
                sleep(2);
                [please giveMePreviousPageOfDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                    _blockFinished = YES;
                    _booksPrevPage = objects;
                    _error = error;
                }];
            }];
        }];
        
        it(@"should return books on all pages", ^{
            //actually _booksPrevPage and _books should have the same objects because they are the same pages
            
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(20.0)] beYes];
            [[_error should] beNil];
            [[_books should] beNonNil];
            [[_booksNextPage should] beNonNil];
            [[_booksPrevPage should] beNonNil];
            
            [[_books should] haveCountOf:2];
            [[_booksPrevPage should] haveCountOf:2];
            [[_booksNextPage should] haveCountOf:2];
            
            Book* bookOne = [_books firstObject];
            Book* bookTwo = [_booksPrevPage firstObject];
            [[bookOne.title should] equal:bookTwo.title];
            [[bookOne.numOfPages should] equal:bookTwo.numOfPages];
        });
    });
    
});

SPEC_END
