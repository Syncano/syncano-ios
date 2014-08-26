//
//  Syncano.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SyncanoParametersListing.h"
#import "SyncanoResponsesListing.h"
#import "SyncanoProtocolsListing.h"
#import "SyncanoReachability.h"

extern NSInteger const kSyncanoMaxNumberOfRequestsInBatchCall;

typedef void (^SyncanoCallback)(SyncanoResponse *response);
typedef void (^SyncanoBatchCallback)(NSArray *responses);

/**
 *  Syncano class should be used to send any requests to Syncano using your credentials. You can use universal sendRequest method or methods listed in implemented protocols.
 */
@interface Syncano : NSObject <SyncanoProtocolAPIKeys, SyncanoProtocolProjects,
SyncanoProtocolCollections, SyncanoProtocolFolders,
SyncanoProtocolDataObjects, SyncanoProtocolUsers,
SyncanoProtocolPermissionRoles, SyncanoProtocolAdministrators>

/**
 *  Your subdomain in Syncano
 */
@property (strong, readonly) NSString *domain;

/**
 *  API Key of used instance
 */
@property (strong, readonly) NSString *apiKey;

/**
 *  Preferred timezone
 */
@property (strong, readwrite) NSString *timezone;

/**
 User authorization key.
 */
@property (strong, readwrite) NSString *authKey;

/**
 Reachability for current instance domain. Use to monitor domain reachability.
 */
@property (strong, readonly, nonatomic) SyncanoReachability *reachability;

///
/// @name Debug
///

/**
 Use to enable/disable logging all requests being sent to Syncano.
 Even when enabled, works only in DEBUG mode!
 */

@property (assign, readwrite) BOOL logAllRequests;

/**
 Use to enable/disable logging all JSON responses incoming from Syncano.
 Even when enabled, works only in DEBUG mode!
 */
@property (assign, readwrite) BOOL logJSONResponses;

///-
/// @name Initialization
///-

/**
 *  Creates Syncano object. You should store it and use it as an shared instance in your application.
 *
 *  @param domain   Your subdomain in Syncano
 *  @param apiKey  API Key of used instance
 *
 *  @return Syncano object, configured to communicate with your subdomain instance using given credentials
 */
+ (Syncano *)syncanoForDomain:(NSString *)domain apiKey:(NSString *)apiKey;

/**
 *  Initializes allocated Syncano object. You should store this initialized object
 *  and use it as an shared instance in your application.
 *
 *  @param domain   Your subdomain in Syncano
 *  @param apiKey  API Key of used instance
 *
 *  @return Syncano initialized object, configured to communicate with your subdomain instance using given credentials
 */
- (Syncano *)initWithDomain:(NSString *)domain apiKey:(NSString *)apiKey;

///-
/// @name Sending requests
///-

/**
 *  Sends a synchronous request to Syncano, using given parameters.
 *
 *  @param params Parameters with which request will be send.
 *
 *  @return Response for request sent with given parameters.
 */
- (SyncanoResponse *)sendRequest:(SyncanoParameters *)params;

/**
 *  Sends an asynchronous request to Syncano, using given parameters.
 *
 *  @param params   Parameters with which request will be send.
 *  @param callback Block that will be performed when response is ready. It will contain response for request sent with given parameters.
 */
- (id <SyncanoRequest> )sendAsyncRequest:(SyncanoParameters *)params
                                callback:(SyncanoCallback)callback;

/**
 *  Sends a synchronous batch request to Syncano with multiple parameters.
 *
 *  @param params Array of parameters that will be send.
 *
 *  @return Array of responses for request with given parameters.
 */
- (NSArray *)sendBatchRequest:(NSArray *)params;

/**
 *  Sends an asynchronous batch request to Syncano with multiple parameters.
 *
 *  @param params   Parameters with which request will be send.
 *  @param callback Block that will be performed when response is ready. It will contain array with responses for request sent with given parameters.
 */
- (id <SyncanoRequest> )sendAsyncBatchRequest:(NSArray *)params
                                     callback:(SyncanoBatchCallback)callback;

/**
 Cancells all pending requests.
 */
- (void)cancellAllRequests;

@end
