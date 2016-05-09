//
//  SCTrace.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 25/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class Syncano;

NS_ASSUME_NONNULL_BEGIN

@interface SCTrace : NSObject
@property (nullable,nonatomic,copy) NSNumber *identifier;
@property (nullable,nonatomic,copy) NSString *status; //TODO: use enum
@property (nullable,nonatomic,copy) NSDictionary *links;
@property (nullable,nonatomic,copy) NSDate *executedAt;
@property (nullable,nonatomic,copy) id result;
@property (nullable,nonatomic,copy) NSNumber *duration;
@property (nullable,nonatomic,copy) NSNumber *scriptIdentifier;

@property (nullable,nonatomic) NSNumber *codeboxIdentifier DEPRECATED_MSG_ATTRIBUTE("Use scriptIdentifier instead.");

- (instancetype)initWithJSONObject:(id)JSONObject andScriptIdentifier:(NSNumber *)scriptIdentifier;

/**
 *  Call trace
 *
 *  @param completion completion block
 */
- (void)fetchWithCompletion:(SCTraceCompletionBlock)completion;

/**
 *  Call trace on provided Synano instance
 *
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
- (void)fetchFromSyncano:(Syncano *)syncano withCompletion:(SCTraceCompletionBlock)completion;
@end

@interface SCTrace (Deprecated)
- (nullable instancetype)initWithJSONObject:(id)JSONObject andCodeboxIdentifier:(NSNumber *)codeboxIdentifier DEPRECATED_MSG_ATTRIBUTE("Use initWithJSONObject:andScriptIdentifier method instead.");
@end
NS_ASSUME_NONNULL_END