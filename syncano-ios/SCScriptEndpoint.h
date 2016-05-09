//
//  SCScriptEndpoint.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/8/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
#import "SCScriptEndpointResponse.h"

@class Syncano;

NS_ASSUME_NONNULL_BEGIN

@interface SCScriptEndpoint : NSObject

/**
 *  Runs script endpoint. Returned data will be an instance of SCScriptEndpointResponse.
 *
 *  @param name       Script Endpoint name
 *  @param completion Completion block
 */
+ (void)runScriptEndpointWithName:(NSString *)name completion:(nullable SCScriptEndpointCompletionBlock)completion;

/**
 *  Runs script endpoint on chosen Syncano Instance. Returned data will be an instance of SCScriptEndpointResponse.
 *
 *  @param name       Script Endpoint name
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runScriptEndpointWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(nullable SCScriptEndpointCompletionBlock)completion;

/**
 *  Runs script endpoint with payload. Returned data will be an instance of SCScriptEndpointResponse.
 *
 *  @param name       Script Endpoint name
 *  @param payload    Paylod to pass into Script Endpoint
 *  @param completion Completion block
 */
+ (void)runScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(nullable SCScriptEndpointCompletionBlock)completion;

/**
 *  Runs script endpoint with payload on chosen Syncano Instance. Returned data will be an instance of SCScriptEndpointResponse.
 *
 *  @param name       Script Endpoint name
 *  @param payload    Payload to pass into Script Endpoint
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(nullable SCScriptEndpointCompletionBlock)completion;

/**
 *  Runs public script endpoint with given hash and name. Returned data will be an instance of SCScriptEndpointResponse.
 *
 *  @param hashTag       Script Endpoint hash
 *  @param name          Script Endpoint name
 *  @param payload       Paylod to pass into Script Endpoint
 *  @param instanceName  Name of Syncano Instance
 *  @param completion    Completion block
 */
+ (void)runPublicScriptEndpointWithHash:(NSString *)hashTag name:(NSString *)name payload:(NSDictionary *)payload forInstanceName:(NSString *)instanceName completion:(nullable SCScriptEndpointCompletionBlock)completion;

/**
 *  Runs public script endpoint with given url. Returned data will be an instance of SCScriptEndpointResponse.
 *
 *  @param urlString     Link to the public Script Endpoint
 *  @param payload       Paylod to pass into Script Endpoint
 *  @param completion    Completion block
 */
+ (void)runPublicScriptEndpointWithURLString:(NSString *)urlString payload:(NSDictionary *)payload completion:(SCScriptEndpointCompletionBlock)completion;

/**
 *  Runs script endpoint with custom response format. Returned data will be an instance of NSData.
 *
 *  @param name       Script Endpoint name
 *  @param completion Completion block
 */
+ (void)runCustomScriptEndpointWithName:(NSString *)name completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs script endpoint with custom reponse format.
 *  CAUTION: By default expected output format for every call to Syncano is JSON. You must modify syncano.apiClient.responseSerializer to fit you needs. f.e. syncano.apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
 *
 *  @param name       Script Endpoint name
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runCustomScriptEndpointWithName:(NSString *)name onSyncano:(Syncano *)syncano completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs script endpoint with payload and custom reponse format. Returned data will be an instance of NSData.
 *
 *  @param name       Script Endpoint name
 *  @param payload    Payload for Script Endpoint
 *  @param completion Completion block
 */
+ (void)runCustomScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs script endpoint with payload and custom reponse format.
 *  CAUTION: By default expected output format for every call to Syncano is JSON. You must modify syncano.apiClient.responseSerializer to fit you needs. f.e. syncano.apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
 *
 *  @param name       Script Endpoint name
 *  @param payload    Payload for Script Endpoint
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
+ (void)runCustomScriptEndpointWithName:(NSString *)name withPayload:(NSDictionary *)payload onSyncano:(Syncano *)syncano completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs public script endpoint. Returned data will be an instance of NSData.
 *
 *  @param hashTag      Script Endpoint's hash tag
 *  @param name         Script Endpoint name
 *  @param payload      Payload for query to Script Endpoint
 *  @param instanceName Syncano instance name
 *  @param completion   Completion block
 */
+ (void)runCustomPublicScriptEndpointWithHash:(NSString *)hashTag name:(NSString *)name payload:(NSDictionary *)payload forInstanceName:(NSString *)instanceName completion:(nullable SCCustomResponseCompletionBlock)completion;

/**
 *  Runs public script endpoint. Returned data will be an instance of NSData.
 *
 *  @param urlString  URL to Script Endpoint
 *  @param payload    Payload for query to Script Endpoint
 *  @param completion Completion block
 */
+ (void)runCustomPublicScriptEndpointWithURLString:(NSString *)urlString payload:(NSDictionary *)payload completion:(nullable SCCustomResponseCompletionBlock)completion;


@end
NS_ASSUME_NONNULL_END