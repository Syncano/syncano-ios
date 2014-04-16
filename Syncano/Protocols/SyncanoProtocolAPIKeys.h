//
//  SyncanoProtocolAPIKeys.h
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_APIKeys.h"
#import "SyncanoResponse_APIKeys.h"

/**
 SyncanoProtocolAPIKeys is used to transmit information about SyncanoClient objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolAPIKeys <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Start session for API key
 
 @param params Parameters for starting API key
 
 @return Response for starting API key
 */
- (SyncanoResponse_APIKeys_StartSession *)apikeyStartSession:(SyncanoParameters_APIKeys_StartSession *)params;
/**
 Create new API key
 
 @param params Parameters of new API key
 
 @return Response for creation of new API key
 */
- (SyncanoResponse_APIKeys_New *)apikeyNew:(SyncanoParameters_APIKeys_New *)params;
/**
 Get API key list
 
 @param params API key list parameters
 
 @return Response for API key list
 */
- (SyncanoResponse_APIKeys_Get *)apikeyGet:(SyncanoParameters_APIKeys_Get *)params;
/**
 Get one API key
 
 @param params Single API key getter parameters
 
 @return Response for single API key
 */
- (SyncanoResponse_APIKeys_GetOne *)apikeyGetOne:(SyncanoParameters_APIKeys_GetOne *)params;
/**
 Update existing API key
 
 @param params Update API key parameters
 
 @return Reponse to existing API key update
 */
- (SyncanoResponse_APIKeys_UpdateDescription *)apikeyUpdateDescription:(SyncanoParameters_APIKeys_UpdateDescription *)params;
/**
 Delete existing API key
 
 @param params Delete API key parameters
 
 @return Reponse to existing API key deletion
 */
- (SyncanoResponse *)apikeyDelete:(SyncanoParameters_APIKeys_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Start session for API key
 
 @param params Parameters for starting API key
 
 @return Response for starting API key
 */
- (void)apikeyStartSession:(SyncanoParameters_APIKeys_StartSession *)params callback:(void (^)(SyncanoResponse_APIKeys_StartSession *response))callback;
/**
 Create new API key
 
 @param params Parameters of new API key
 
 @return Response for creation of new API key
 */
- (void)apikeyNew:(SyncanoParameters_APIKeys_New *)params callback:(void (^)(SyncanoResponse_APIKeys_New *response))callback;
/**
 Get API key list
 
 @param params API key list parameters
 
 @return Response for API key list
 */
- (void)apikeyGet:(SyncanoParameters_APIKeys_Get *)params callback:(void (^)(SyncanoResponse_APIKeys_Get *response))callback;
/**
 Get one API key
 
 @param params Single API key getter parameters
 
 @return Response for single API key
 */
- (void)apikeyGetOne:(SyncanoParameters_APIKeys_GetOne *)params callback:(void (^)(SyncanoResponse_APIKeys_GetOne *response))callback;
/**
 Update existing API key
 
 @param params Update API key parameters
 
 @return Reponse to existing API key update
 */
- (void)apikeyUpdateDescription:(SyncanoParameters_APIKeys_UpdateDescription *)params callback:(void (^)(SyncanoResponse_APIKeys_UpdateDescription *response))callback;
/**
 Delete existing API key
 
 @param params Delete API key parameters
 
 @return Reponse to existing API key deletion
 */
- (void)apikeyDelete:(SyncanoParameters_APIKeys_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end
