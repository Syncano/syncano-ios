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

/**
 *  You should set GOOGLE_TOKEN_KEY, FACEBOOK_TOKEN_KEY, TWITTER_TOKEN_KEY, LINKEDIN_TOKEN_KEY for this tests to work
 */
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

describe(@"File fetch", ^{
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    NSString *apiKey = environment[@"API_KEY"];
    NSString *instanceName = environment[@"INSTANCE_NAME"];
    
    beforeAll(^{
        [Syncano sharedInstanceWithApiKey:apiKey instanceName:instanceName];
    });
    
    it(@"download a file to disk", ^{
        NSURL *storePathDocuments = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *storePath = [storePathDocuments URLByAppendingPathComponent:@"saabManual.pdf"];
        
        __block BOOL _blockFinished;
        __block NSError* _errorPlease;
        __block NSError* _errorFile;
        __block int64_t _bytesWritten = 0;
        __block Book* _book;
        [[Book please] giveMeDataObjectsWithPredicate:[SCPredicate whereKey:@"id" isEqualToNumber:@(8)] parameters:nil completion:^(NSArray *objects, NSError *error) {
            if(error) {
                _errorPlease = error;
                _blockFinished = YES;
                return;
            }
            
            _book = objects[0];
            _book.content.storeURL = storePath;
            [_book.content fetchToFileInBackgroundWithProgress:^(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                _bytesWritten = totalBytesWritten;
                NSLog(@"%lld",totalBytesWritten);
            } completion:^(NSURLResponse *response, NSError *error) {
                _errorFile = error;
                _blockFinished = YES;
            }];
        }];
        if([[NSFileManager defaultManager] isWritableFileAtPath:storePathDocuments.path]) {
            [[expectFutureValue(theValue(_blockFinished)) shouldEventuallyBeforeTimingOutAfter(30.0)] beYes];
            [[_errorPlease should] beNil];
            [[_errorFile should] beNil];
            [[_book shouldNot] beNil];
            NSData* content = [NSData dataWithContentsOfURL:storePath];
            [[md5FromNSData(content) should] equal:@"0c64a3389d3235ac345c528b3f3875b5"];
            [[theValue(_bytesWritten) should] equal:theValue(24516040)];
            [[NSFileManager defaultManager] removeItemAtURL:storePath error:NULL];
        }
    });
});

SPEC_END