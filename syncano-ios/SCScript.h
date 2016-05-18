//
//  SCScript.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/8/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "SCTrace.h"

@class Syncano;

NS_ASSUME_NONNULL_BEGIN

@interface SCScript : NSObject

@property (nullable,nonatomic,copy) NSNumber *identifier;
@property (nullable,nonatomic,copy) NSDictionary *config;
@property (nullable,nonatomic,copy) NSString *runtimeName;
@property (nullable,nonatomic,copy) NSString *name;
@property (nullable,nonatomic,copy) NSString *desc;
@property (nullable,nonatomic,copy) NSString *source;
@property (nullable,nonatomic,copy) NSDate *createdAt;
@property (nullable,nonatomic,copy) NSDate *updatedAt;
@property (nullable,nonatomic,copy) NSDictionary *links;

/**
 *  Runs code box on shared Syncano Instance
 *  Running your code this way will return immediately without waiting until execution is finished
 *  Use SCTrace objects from  completion block to ask for results
 *  @param params Parameters to pass into the Script
 *  @param completion Completion block.
 *  @code [trace fetchWithCompletion:^(SCTrace* trace, NSError* error){}];
 */
+ (void)runScriptWithId:(NSNumber *)scriptId params:(NSDictionary *)params completion:(nullable SCScriptCompletionBlock)completion;

/**
 *  Runs code box on a chosen Syncano Instance
 *  Running your code this way will return immediately without waiting until execution is finished
 *  Use SCTrace objects from  completion block to ask for results
 *  @param params Parameters to pass into the Script
 *  @param completion Completion block.
 *  @param syncano Chosen Syncano Instance
 *  @code [trace fetchWithCompletion:^(SCTrace* trace, NSError* error){}];
 */
+ (void)runScriptWithId:(NSNumber *)scriptId params:(NSDictionary *)params onSyncano:(Syncano *)syncano completion:(nullable SCScriptCompletionBlock)completion;

@end
NS_ASSUME_NONNULL_END