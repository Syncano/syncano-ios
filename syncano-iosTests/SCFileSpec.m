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
        [file fetchInBackgroundWithCompletion:^(NSData *data, NSError *error) {
            image = [UIImage imageWithData:data];
            _blockFinished = YES;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[image shouldEventually] beKindOfClass:[UIImage class]];

    });

});

SPEC_END
