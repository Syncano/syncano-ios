//
//  SCDataObjectSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import <UIKit/UIKit.h>
#import "Syncano.h"
#import "SCFile.h"
#import "SCAPIClient+SCFile.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHPathHelpers.h"


SPEC_BEGIN(SCFileSpec)

describe(@"SCFile", ^{
    
    it(@"should initialize with data", ^{
        NSBundle* bundle = [NSBundle bundleForClass:self.class];
        NSString *filePath = [bundle pathForResource:@"syncano-white" ofType:@"png"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        SCFile *file = [SCFile fileWithaData:data];
        [[file shouldNot] beNil];
    });

    it(@"should fetch file", ^{
        
        [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            // Stub it with our "wsresponse.json" stub file
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"syncano-white.png",self.class)
                                                    statusCode:200 headers:nil];
        }];
        
        SCFile *file = [SCFile new];
        file.fileURL = [NSURL URLWithString:@""];
        __block BOOL _blockFinished;
        __block UIImage *image;
        __block NSData *imageData;
        [file fetchInBackgroundWithCompletion:^(NSData *data, NSError *error) {
            imageData = data;
            image = [UIImage imageWithData:data];
            _blockFinished = YES;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[imageData should] beNonNil];
        [[image should] beKindOfClass:[UIImage class]];

    });
    
    it(@"should fetch file to disk", ^{
        
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return YES;
        } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"syncano-white.png",self.class)
                                                    statusCode:200 headers:nil];
        }];
        
        SCFile *file = [SCFile new];
        file.fileURL = [NSURL URLWithString:@""];
        
        NSURL *storePath = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        storePath = [storePath URLByAppendingPathComponent:@"syncano-white.png"];
        
        [[storePath should] beNonNil];
        
        __block BOOL _blockFinished;
        __block NSURLSessionDownloadTask *_reportedDownloadTask;
        __block int64_t _bytesWritten = 0;
        NSURLSessionDownloadTask *downloadTask = [file fetchToFileInBackground:storePath
                         withProgress:^(NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
                             _reportedDownloadTask = downloadTask;
                             _bytesWritten = totalBytesWritten;
        } completion:^(NSURLResponse *response, NSError *error) {
            _blockFinished = YES;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[file.storeURL should] equal:storePath];
        [[downloadTask should] beIdenticalTo:_reportedDownloadTask];
        [[theValue(_bytesWritten) should] beGreaterThan:theValue(0)];//reports progress
        
        NSData* resultData = [NSData dataWithContentsOfURL:storePath];
        NSData* fileData = [NSData dataWithContentsOfFile:OHPathForFile(@"syncano-white.png",self.class)];
        [[fileData should] beNonNil];
        [[resultData should] equal:fileData];
        
        [[NSFileManager defaultManager] removeItemAtURL:storePath error:NULL];
    });

});

SPEC_END
