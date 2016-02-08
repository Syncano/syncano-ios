//
//  FileFetchSpec.m
//  syncano-ios
//
//  Created by Jakub Machoń on 01.02.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "Book.h"
#import <CommonCrypto/CommonDigest.h>

SPEC_BEGIN(FileFetchSpec)

NSString* (^md5FromNSData) (NSData *) = ^NSString* (NSData *data) {
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data.bytes, (CC_LONG)data.length, md5Buffer);
    
    // Convert unsigned char buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
};

static const NSString* const kFileMD5Sum = @"0c64a3389d3235ac345c528b3f3875b5";
static const NSInteger kFileSize = 24516040;

describe(@"File fetch", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
        
    });
    
    __block Book* _book;
    
    it(@"Needs object",^{
        __block BOOL _blockFinished;
        __block NSError* _error;
        [[Book please] giveMeDataObjectsWithPredicate:[SCPredicate whereKey:@"id" isEqualToNumber:@(8)] parameters:nil completion:^(NSArray *objects, NSError *error) {
            _blockFinished = YES;
            _error = error;
            _book = objects.firstObject;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(10.0)] beYes];
        [[_error should] beNil];
        [[_book shouldNot] beNil];
        
    });
    
    it(@"downloads a file to temporary location", ^{
        __block BOOL _blockFinished;
        __block NSError* _error;
        __block int64_t _bytesWritten = 0;
        __block NSURL* _filePath;
        
        [_book.content fetchToFileInBackgroundWithProgress:^(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            _bytesWritten = totalBytesWritten;
        } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            _error = error;
            _blockFinished = YES;
            _filePath = filePath;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(30.0)] beYes];
        if(_error.code != -999) {//xctool write to path error workaround
            [[_error should] beNil];
            NSData* content = [NSData dataWithContentsOfURL:_filePath];
            [[content shouldNot] beNil];
            [[md5FromNSData(content) should] equal:kFileMD5Sum];
            [[theValue(_bytesWritten) should] equal:theValue(kFileSize)];
            [[NSFileManager defaultManager] removeItemAtURL:_filePath error:NULL];
        }
    });

    
    it(@"downloads a file to disk", ^{
        NSURL *storePathDocuments = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *storePath = [storePathDocuments URLByAppendingPathComponent:@"saabManual.pdf"];
        
        __block BOOL _blockFinished;
        __block NSError* _error;
        __block int64_t _bytesWritten = 0;
        __block NSURL* _filePath;
        
        _book.content.storeURL = storePath;
        [_book.content fetchToFileInBackgroundWithProgress:^(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            _bytesWritten = totalBytesWritten;
        } completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            _error = error;
            _blockFinished = YES;
            _filePath = filePath;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(30.0)] beYes];
        if(_error.code != -999) {//xctool write to path error workaround
            [[_error should] beNil];
            [[_filePath should] equal:_book.content.storeURL];
            NSData* content = [NSData dataWithContentsOfURL:storePath];
            [[content shouldNot] beNil];
            [[md5FromNSData(content) should] equal:kFileMD5Sum];
            [[theValue(_bytesWritten) should] equal:theValue(kFileSize)];
            [[NSFileManager defaultManager] removeItemAtURL:storePath error:NULL];
        }
    });
    
});

SPEC_END