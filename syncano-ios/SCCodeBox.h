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
 *  Runs code box on server
 *
 *  @param completion completion block
 */
+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params completion:(SCCodeBoxCompletionBlock)completion;

+ (void)runCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params onSyncano:(Syncano *)syncano completion:(SCCodeBoxCompletionBlock)completion;

/**
 *  Runs code box with custom response format on server. Returned data will be an instance of NSData.
 *
 *  @param codeBoxId  id of the codeBox
 *  @param params     run parameters for the codeBox
 *  @param completion completion block
 */
+ (void)runCustomCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params completion:(SCCustomResponseCompletionBlock)completion;

/**
 *  Runs code box with custom response format on server. 
 *  CAUTION: By default expected output format for every call to Syncano is JSON. You must modify syncano.apiClient.responseSerializer to fit you needs. f.e. syncano.apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
 *
 *  @param codeBoxId  id of the codeBox
 *  @param params     run parameters for the codeBox
 *  @param syncano    Syncano instance object
 *  @param completion completion block
 */
+ (void)runCustomCodeBoxWithId:(NSNumber *)codeBoxId params:(NSDictionary *)params onSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion;

@end
