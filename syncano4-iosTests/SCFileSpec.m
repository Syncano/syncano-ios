//
//  SCDataObjectSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "SCFile.h"
#import "SCAPIClient+SCFile.h"
#import <OHHTTPStubs/OHHTTPStubs.h>

SPEC_BEGIN(SCFileSpec)

describe(@"SCFile", ^{
    

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
        __block id image;
        [file fetchInBackgroundWithCompletion:^(NSData *data, NSError *error) {
            image = [UIImage imageWithData:data];
            _blockFinished = YES;
        }];
        [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
        [[image shouldEventually] beKindOfClass:[UIImage class]];

    });

});

SPEC_END
