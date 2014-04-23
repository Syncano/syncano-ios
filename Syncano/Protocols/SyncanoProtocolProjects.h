//
//  SyncanoProtocolProjects.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolProjects_h
#define Syncano_SyncanoProtocolProjects_h

#import "SyncanoParameters_Projects.h"
#import "SyncanoResponse_Projects.h"

/**
 SyncanoProtocolProjects is used to transmit information about SyncanoProject objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolProjects <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Create new project
 
 @param params Parameters of new project
 
 @return Response for creation of new project
 */
- (SyncanoResponse_Projects_New *)projectNew:(SyncanoParameters_Projects_New *)params;
/**
 Get project list
 
 @param params Project list parameters
 
 @return Response for project list
 */
- (SyncanoResponse_Projects_Get *)projectGet:(SyncanoParameters_Projects_Get *)params;
/**
 Get one project
 
 @param params Single project getter parameters
 
 @return Response for single project
 */
- (SyncanoResponse_Projects_GetOne *)projectGetOne:(SyncanoParameters_Projects_GetOne *)params;
/**
 Update existing project
 
 @param params Update project parameters
 
 @return Reponse to existing project update
 */
- (SyncanoResponse_Projects_Update *)projectUpdate:(SyncanoParameters_Projects_Update *)params;
/**
 Delete existing project
 
 @param params Delete project parameters
 
 @return Reponse to existing project deletion
 */
- (SyncanoResponse *)projectDelete:(SyncanoParameters_Projects_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Create new project
 
 @param params Parameters of new project
 */
- (void)projectNew:(SyncanoParameters_Projects_New *)params callback:(void (^)(SyncanoResponse_Projects_New *response))callback;
/**
 Get project list
 
 @param params Project list parameters
 */
- (void)projectGet:(SyncanoParameters_Projects_Get *)params callback:(void (^)(SyncanoResponse_Projects_Get *response))callback;
/**
 Get one project
 
 @param params Single project getter parameters
 */
- (void)projectGetOne:(SyncanoParameters_Projects_GetOne *)params callback:(void (^)(SyncanoResponse_Projects_GetOne *response))callback;
/**
 Update existing project
 
 @param params Update project parameters
 */
- (void)projectUpdate:(SyncanoParameters_Projects_Update *)params callback:(void (^)(SyncanoResponse_Projects_Update *response))callback;
/**
 Delete existing project
 
 @param params Delete project parameters
 */
- (void)projectDelete:(SyncanoParameters_Projects_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end

#endif
