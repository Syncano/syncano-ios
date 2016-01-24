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

@interface SCWebhook : NSObject


+ (void)runWebhookWithName:(NSString *)name completion:(SCWebhookCompletionBlock)completion;
+ (void)runWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion;

+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCWebhookCompletionBlock)completion;
+ (void)runWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCWebhookCompletionBlock)completion;


+ (void)runPublicWebhookWithHash:(NSString *)hashTag name:(NSString *)name params:(NSDictionary *)params forInstanceName:(NSString *)instanceName completion:(SCWebhookCompletionBlock)completion;
+ (void)runPublicWebhookWithURLString:(NSString *)urlString params:(NSDictionary *)params completion:(SCWebhookCompletionBlock)completion;


/**
 *  Runs webhook with custom response format. Returned data will be an instance of NSData.
 *
 *  @param name       Webhook name
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name completion:(SCCustomResponseCompletionBlock)completion;

/**
 *  Runs webhook with custom reponse format.
 *  CAUTION: By default expected output format for every call to Syncano is JSON. You must modify syncano.apiClient.responseSerializer to fit you needs. f.e. syncano.apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
 *
 *  @param name       Webhook name
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion;

/**
 *  Runs webhook with payload and custom reponse format. Returned data will be an instance of NSData.
 *
 *  @param name       Webhook name
 *  @param payload    Payload for webhook
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(SCCustomResponseCompletionBlock)completion;

/**
 *  Runs webhook with payload and custom reponse format.
 *  CAUTION: By default expected output format for every call to Syncano is JSON. You must modify syncano.apiClient.responseSerializer to fit you needs. f.e. syncano.apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
 *
 *  @param name       Webhook name
 *  @param payload    Payload for webhook
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runCustomWebhookWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion;

/**
 *  Runs public webhook. Returned data will be an instance of NSData.
 *
 *  @param hashTag      Webhook's hash tag
 *  @param name         Webhook name
 *  @param params       Params for query to webhook
 *  @param instanceName Syncano instance name
 *  @param completion   Completion block
 */
+ (void)runCustomPublicWebhookWithHash:(NSString *)hashTag name:(NSString *)name params:(NSDictionary *)params forInstanceName:(NSString *)instanceName completion:(SCCustomResponseCompletionBlock)completion;

/**
 *  Runs public webhook. Returned data will be an instance of NSData.
 *
 *  @param urlString  URL to webhook
 *  @param params     Params for query to webhook
 *  @param completion Completion block
 */
+ (void)runCustomPublicWebhookWithURLString:(NSString *)urlString params:(NSDictionary *)params completion:(SCCustomResponseCompletionBlock)completion;

@end
