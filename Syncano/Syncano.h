//
//  Syncano.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013-2015 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncanoReachability.h"
#import "SyncanoObjectProtocol.h"
#import "SyncanoParameters.h"
#import "SyncanoArray.m"

extern NSInteger const kSyncanoDefaultPageSize;
typedef void(^SyncanoObjectBlock)(NSURLSessionDataTask *task, id<SyncanoObjectProtocol> object);
typedef void(^SyncanoArrayBlock)(NSURLSessionDataTask *task, SyncanoArray *array);
typedef void(^SyncanoErrorBlock)(NSURLSessionDataTask *task, NSError *error);

@interface Syncano : NSObject

@property (strong, readonly, nonatomic) SyncanoReachability *reachability;
@property (nonatomic, copy, readonly) NSString *name;

// managing Syncano proxy
+ (instancetype)sharedInstance;
+ (instancetype)setSharedInstanceName:(NSString *)name;
+ (instancetype)syncanoWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

// managing objects
- (NSURLSessionDataTask *)get:(Class)class params:(SyncanoParameters *)params success:(SyncanoObjectBlock)success failure:(SyncanoErrorBlock)failure;
- (NSURLSessionDataTask *)getArrayOf:(Class)class params:(SyncanoParameters *)params success:(SyncanoArrayBlock)success failure:(SyncanoErrorBlock)failure;

@end
