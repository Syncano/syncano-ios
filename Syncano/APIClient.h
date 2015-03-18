//
//  APIClient.h
//  Syncano
//
//  Created by Mateusz on 16.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface APIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@property (nonatomic, assign) BOOL jsonOutput;

@end
