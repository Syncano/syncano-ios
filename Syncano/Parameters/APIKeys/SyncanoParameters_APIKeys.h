//
//  SyncanoParameters_APIKeys.h
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
 Parameters for starting session
 */
@interface SyncanoParameters_APIKeys_StartSession : SyncanoParameters
@end

/**
 Parameters for creating new APIKey
 */
@interface SyncanoParameters_APIKeys_New : SyncanoParameters
@property (strong) NSString *roleId;
@property (strong) NSString *description;

/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_New*)initWithRoleId:(NSString*)roleId description:(NSString*)description;

@end

/**
 Parameters for getting API keys list
 */
@interface SyncanoParameters_APIKeys_Get : SyncanoParameters
@end

/**
 Parameters for getting one API key
 */
@interface SyncanoParameters_APIKeys_GetOne : SyncanoParameters
/// API client id. If not specified, will use current client.
@property (strong) NSString *clientId; //optional
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_GetOne*)initWithClientId:(NSString*)clientId;

@end

/**
 Parameters for updating API key description
 */
@interface SyncanoParameters_APIKeys_UpdateDescription : SyncanoParameters
@property (strong) NSString *description;
// API client id. If not specified, will update current client.
@property (strong) NSString *clientId;
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_UpdateDescription*)initWithDescription:(NSString*)description;
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_UpdateDescription*)initWithDescription:(NSString*)description clientId:(NSString*)clientId;

@end

/**
 Parameters for API key deletion
 */
@interface SyncanoParameters_APIKeys_Delete : SyncanoParameters
@property (strong) NSString *clientId;
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_APIKeys_Delete*)initWithClientId:(NSString*)clientId;

@end
