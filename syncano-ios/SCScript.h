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

@interface SCScript : NSObject

@property (nonatomic,copy) NSNumber *identifier;
@property (nonatomic,copy) NSDictionary *config;
@property (nonatomic,copy) NSString *runtimeName;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSDate *createdAt;
@property (nonatomic,copy) NSDate *updatedAt;
@property (nonatomic,copy) NSDictionary *links;

/**
 *  Runs code box on shared Syncano Instance
 *  Running your code this way will return immediately without waiting until execution is finished
 *  Use SCTrace objects from  completion block to ask for results
 *  @param params Parameters to pass into the Script
 *  @param completion Completion block.
 *  @code [trace fetchWithCompletion:^(SCTrace* trace, NSError* error){}];
 */
+ (void)runScriptWithId:(NSNumber *)scriptId params:(NSDictionary *)params completion:(SCScriptCompletionBlock)completion;

/**
 *  Runs code box on a chosen Syncano Instance
 *  Running your code this way will return immediately without waiting until execution is finished
 *  Use SCTrace objects from  completion block to ask for results
 *  @param params Parameters to pass into the Script
 *  @param completion Completion block.
 *  @param syncano Chosen Syncano Instance
 *  @code [trace fetchWithCompletion:^(SCTrace* trace, NSError* error){}];
 */
+ (void)runScriptWithId:(NSNumber *)scriptId params:(NSDictionary *)params onSyncano:(Syncano *)syncano completion:(SCScriptCompletionBlock)completion;

@end
