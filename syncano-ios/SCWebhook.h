//
//  SCWebhook.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 28/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "SCWebhookResponseObject.h"

@class Syncano;

NS_ASSUME_NONNULL_BEGIN

@interface SCWebhook : NSObject

/**
 *  Runs webhook using singleton Syncano instance
 *
 *  @param name       webhook name
 *  @param completion completion block
 */
+ (void)runWebhookWithName:(NSString *)name completion:(nullable SCWebhookCompletionBlock)completion;

/**
 *  Runs webhook using provided Syncano instance
 *
 *  @param name       webhook name
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
+ (void)runWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(nullable SCWebhookCompletionBlock)completion;

/**
 *  Runs webhook with payload using singleton Syncano instance
 *
 *  @param name       webhook name
 *  @param payload    payload
 *  @param completion completion block
 */
+ (void)runWebhookWithName:(NSString *)name withPayload:(nullable NSDictionary *)payload completion:(nullable SCWebhookCompletionBlock)completion;

/**
 *  Runs webhook with payload using provided Syncano instance
 *
 *  @param name       webhook name
 *  @param payload    payload
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
+ (void)runWebhookWithName:(NSString *)name withPayload:(nullable NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(nullable SCWebhookCompletionBlock)completion;

/**
 *  Runs public webhook.
 *
 *  @param hashTag      Webhook's hash tag
 *  @param name         Webhook name
 *  @param params       Params for query to webhook
 *  @param instanceName Syncano instance name
 *  @param completion   Completion block
 */
+ (void)runPublicWebhookWithHash:(NSString *)hashTag name:(NSString *)name params:(nullable NSDictionary *)params forInstanceName:(NSString *)instanceName completion:(nullable SCWebhookCompletionBlock)completion;

/**
 *  Runs public webhook.
 *
 *  @param urlString  URL to webhook
 *  @param params     Params for query to webhook
 *  @param completion Completion block
 */
+ (void)runPublicWebhookWithURLString:(NSString *)urlString params:(nullable NSDictionary *)params completion:(nullable SCWebhookCompletionBlock)completion;


/**
 *  Runs webhook with custom response format. Returned data will be an instance of NSData.
 *
 *  @param name       Webhook name
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs webhook with custom reponse format.
 *  CAUTION: By default expected output format for every call to Syncano is JSON. You must modify syncano.apiClient.responseSerializer to fit you needs. f.e. syncano.apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
 *
 *  @param name       Webhook name
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs webhook with payload and custom reponse format. Returned data will be an instance of NSData.
 *
 *  @param name       Webhook name
 *  @param payload    Payload for webhook
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name withPayload:(nullable NSDictionary *)payload completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs webhook with payload and custom reponse format.
 *  CAUTION: By default expected output format for every call to Syncano is JSON. You must modify syncano.apiClient.responseSerializer to fit you needs. f.e. syncano.apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
 *
 *  @param name       Webhook name
 *  @param payload    Payload for webhook
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name withPayload:(nullable NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs public webhook. Returned data will be an instance of NSData.
 *
 *  @param hashTag      Webhook's hash tag
 *  @param name         Webhook name
 *  @param params       Params for query to webhook
 *  @param instanceName Syncano instance name
 *  @param completion   Completion block
 */
+ (void)runCustomPublicWebhookWithHash:(NSString *)hashTag name:(NSString *)name params:(nullable NSDictionary *)params forInstanceName:(NSString *)instanceName completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs public webhook. Returned data will be an instance of NSData.
 *
 *  @param urlString  URL to webhook
 *  @param params     Params for query to webhook
 *  @param completion Completion block
 */
+ (void)runCustomPublicWebhookWithURLString:(NSString *)urlString params:(nullable NSDictionary *)params completion:(nullable SCCustomResponseCompletionBlock)completion;

@end
NS_ASSUME_NONNULL_END