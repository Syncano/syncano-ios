//
//  SCBatchRequest.h
//  syncano-ios
//
//  Created by Jan Lipmann on 01/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class SCAPIClient;

@interface SCBatchRequest : NSObject
@property (nonatomic) SCRequestMethod method;
@property (nonatomic,retain) NSString *path;
@property (nonatomic,retain) NSDictionary *payload;

+ (SCBatchRequest *)requestWithMethod:(SCRequestMethod)method path:(NSString *)path payload:(NSDictionary *)payload;

- (NSDictionary *)encodedRequestForAPIClient:(SCAPIClient *)apiClient;

@end
