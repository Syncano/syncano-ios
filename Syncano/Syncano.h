//
//  Syncano.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013-2015 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncanoReachability.h"
#import "SyncanoObject.h"
#import "SyncanoParameters.h"
#import "SyncanoRequest.h"
#import "SyncanoArray.m"

extern NSInteger const kSyncanoDefaultPageSize;
typedef void(^SyncanoObjectBlock)(id<SyncanoRequest> *request, SyncanoObject *object);
typedef void(^SyncanoArrayBlock)(id<SyncanoRequest> *request, SyncanoArray *array);
typedef void(^SyncanoErrorBlock)(id<SyncanoRequest> *request, NSError *error);

@interface Syncano : NSObject

@property (strong, readonly, nonatomic) SyncanoReachability *reachability;
@property (nonatomic, copy, readonly) NSString *name;

// managing Syncano proxy
+ (instancetype)sharedInstance;
+ (instancetype)setSharedInstanceName:(NSString *)name;
+ (instancetype)syncanoWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

// managing objects
- (id<SyncanoRequest>)get:(Class)class params:(SyncanoParameters *)params success:(SyncanoObjectBlock)success failure:(SyncanoErrorBlock)failure;
- (id<SyncanoRequest>)getArrayOf:(Class)class params:(SyncanoParameters *)params success:(SyncanoArrayBlock)success failure:(SyncanoErrorBlock)failure;

@end
