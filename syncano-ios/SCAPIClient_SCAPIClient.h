//
//  SCAPIClient_SCAPIClient.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/16/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCAPIClient.h"
#import "SCRequestQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCAPIClient ()
@property (nullable,nonatomic,copy) NSString *apiKey;
@property (nullable,nonatomic,copy) NSString *instanceName;
@property (nullable,nonatomic,retain) SCRequestQueue *requestQueue;
@property (nullable,nonatomic,retain) NSMutableArray *requestsBeingProcessed;
@property (nonatomic) NSInteger maxConcurentRequestsInQueue;
@property (nullable,nonatomic,retain) AFNetworkReachabilityManager *networkReachabilityManager;
@property (nonatomic, assign) SCAPIVersion apiVersion;

/**
 *  Initializes SCApiClient with provided version, api key and instance name
 *
 *  @param apiVersion   API version to use with this API client
 *  @param apiKey       API KE
 *  @param instanceName syncano instance name
 *
 *  @return SCAPIClient
 */
- (instancetype)initWithApiVersion:(SCAPIVersion)apiVersion apiKey:(NSString *)apiKey instanceName:(NSString *)instanceName;

@end
NS_ASSUME_NONNULL_END