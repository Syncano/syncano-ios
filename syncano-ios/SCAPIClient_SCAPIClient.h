//
//  SCAPIClient_SCAPIClient.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 3/16/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCAPIClient.h"
#import "SCRequestQueue.h"

@interface SCAPIClient ()
@property (nonatomic,copy) NSString *apiKey;
@property (nonatomic,copy) NSString *instanceName;
@property (nonatomic,retain) SCRequestQueue *requestQueue;
@property (nonatomic,retain) NSMutableArray *requestsBeingProcessed;
@property (nonatomic) NSInteger maxConcurentRequestsInQueue;
@property (nonatomic,retain) AFNetworkReachabilityManager *networkReachabilityManager;
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

/**
 @deprecated This method is deprecated. Please use initWithApiVersion:apiKey:instanceName: instead when initializing API Client to use it with Syncano
 */
- (instancetype)initWithBaseURL:(NSURL *)url apiKey:(NSString *)apiKey instanceName:(NSString *)instanceName DEPRECATED_MSG_ATTRIBUTE("Use initWithApiVersion:apiKey:instanceName: method instead.");
@end
