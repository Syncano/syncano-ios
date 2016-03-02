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

SPEC_BEGIN(DataObjectFetchSpec)

describe(@"DataObjectFetchSpec", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    });
    
    context(@"data object please", ^{
        
        it(@"should return object count", ^{
            __block BOOL _blockFinished;
            __block NSError *_fetchError;
            __block NSNumber *_objectCount;

            SCPlease *bookPlease = [Book please];
            [bookPlease giveMeDataObjectsWithParameters:@{SCPleaseParameterIncludeCount : @(YES)} completion:^(NSArray *objects, NSError *error) {
                NSLog(@"%@",bookPlease.objectsCount);
                NSLog(@"%@",error);
                _blockFinished = YES;
                _fetchError = error;
                _objectCount = bookPlease.objectsCount;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_fetchError should] beNil];
            [[_objectCount shouldNot] beNil];
        });
        it(@"should not return object count", ^{
            __block BOOL _blockFinished;
            __block NSError *_fetchError;
            __block NSNumber *_objectCount;
            
            SCPlease *bookPlease = [Book please];
            [bookPlease giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
                NSLog(@"%@",bookPlease.objectsCount);
                NSLog(@"%@",error);
                _blockFinished = YES;
                _fetchError = error;
                _objectCount = bookPlease.objectsCount;
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
            [[_fetchError should] beNil];
            [[_objectCount should] beNil];
        });
    });
});

SPEC_END
