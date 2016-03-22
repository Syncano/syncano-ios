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

@interface SCCodeBox : NSObject
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
 *  Runs code box on server using singleton Syncano instance
 *
 *  @param codeBoxId  codebox identifier
 *  @param params     params
 *  @param completion completion block
 */
+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params completion:(SCCodeBoxCompletionBlock)completion;

/**
 *  Runs code box on server using provided Syncano instance
 *
 *  @param codeBoxId  codebox identifier
 *  @param params     params
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params onSyncano:(Syncano *)syncano completion:(SCCodeBoxCompletionBlock)completion;

@end
