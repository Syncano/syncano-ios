//
//  SCCodeBox.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 22/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "SCTrace.h"

@class Syncano;

NS_ASSUME_NONNULL_BEGIN

@interface SCCodeBox : NSObject
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
 *  Runs code box on server using singleton Syncano instance
 *
 *  @param codeBoxId  codebox identifier
 *  @param params     params
 *  @param completion completion block
 */
+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(nullable NSDictionary *)params completion:(nullable SCCodeBoxCompletionBlock)completion;

/**
 *  Runs code box on server using provided Syncano instance
 *
 *  @param codeBoxId  codebox identifier
 *  @param params     params
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(nullable NSDictionary *)params onSyncano:(Syncano *)syncano completion:(nullable SCCodeBoxCompletionBlock)completion;

@end
NS_ASSUME_NONNULL_END