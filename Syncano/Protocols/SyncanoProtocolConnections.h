//
//  SyncanoProtocolConnections.h
//  Syncano
//
//  Created by Syncano Inc. on 13/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Connections.h"
#import "SyncanoResponse_Connections.h"

/**
 SyncanoProtocolConnections is used to transmit information about SyncanoConnection objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
  @note This protocol defines only asynchronous methods, it is to be used only with SyncanoSyncServer
 */
@protocol SyncanoProtocolConnections <NSObject>
@required

#pragma mark - Synchronized

//Not present, to be used only with SyncServer

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Get connection list
 
 @param params Connection list parameters
 
 @return Response for connection list
 */
- (void)connectionGet:(SyncanoParameters_Connections_Get *)params callback:(void (^)(SyncanoResponse_Connections_Get *response))callback;
/**
 Get all connections list
 
 @param params connection list parameters
 
 @return Response for connection list
 */
- (void)connectionGetAll:(SyncanoParameters_Connections_Get_All *)params callback:(void (^)(SyncanoResponse_Connections_Get_All *response))callback;
/**
 Update existing connection
 
 @param params Update connection parameters
 
 @return Reponse to existing connection update
 */
- (void)connectionUpdate:(SyncanoParameters_Connections_Update *)params callback:(void (^)(SyncanoResponse_Connections_Update *response))callback;

@end
