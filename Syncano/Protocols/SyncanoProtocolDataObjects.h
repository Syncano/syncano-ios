//
//  SyncanoProtocolDataObjects.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolDataObjects_h
#define Syncano_SyncanoProtocolDataObjects_h

#import "SyncanoParameters_DataObjects.h"
#import "SyncanoResponse_DataObjects.h"

/**
 SyncanoProtocolDataObjects is used to transmit information about SyncanoData objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolDataObjects <NSObject>
@required

#pragma mark - Synchronized

///-
/// @name Synchronous requests
///-

/**
 Create new data object
 
 @param params Parameters of new data object
 
 @return Response for creation of new data object
 */
- (SyncanoResponse_DataObjects_New *)dataNew:(SyncanoParameters_DataObjects_New *)params;
/**
 Get data object list
 
 @param params Data object list parameters
 
 @return Response for data object list
 */
- (SyncanoResponse_DataObjects_Get *)dataGet:(SyncanoParameters_DataObjects_Get *)params;
/**
 Get one data object
 
 @param params Single data object getter parameters
 
 @return Response for single data object
 */
- (SyncanoResponse_DataObjects_GetOne *)dataGetOne:(SyncanoParameters_DataObjects_GetOne *)params;
/**
 Update existing data object
 
 @param params Update data object parameters
 
 @return Reponse to existing data object update
 */
- (SyncanoResponse_DataObjects_Update *)dataUpdate:(SyncanoParameters_DataObjects_Update *)params;
/**
 Move existing data object
 
 @param params Move data object parameters
 
 @return Reponse to existing data object move
 */
- (SyncanoResponse *)dataMove:(SyncanoParameters_DataObjects_Move *)params;
/**
 Copy existing data object
 
 @param params Copy data object parameters
 
 @return Reponse to existing data object copy
 */
- (SyncanoResponse_DataObjects_Copy *)dataCopy:(SyncanoParameters_DataObjects_Copy *)params;
/**
 Add parent to existing data object
 
 @param params Add parent to data object parameters
 
 @return Reponse to existing data object parent addition
 */
- (SyncanoResponse *)dataAddParent:(SyncanoParameters_DataObjects_AddParent *)params;
/**
 Remove parent to existing data object
 
 @param params Remove parent to data object parameters
 
 @return Reponse to existing data object parent removal
 */
- (SyncanoResponse *)dataRemoveParent:(SyncanoParameters_DataObjects_RemoveParent *)params;
/**
 Delete existing data object
 
 @param params Delete data object parameters
 
 @return Reponse to existing data object deletion
 */
- (SyncanoResponse *)dataDelete:(SyncanoParameters_DataObjects_Delete *)params;
/**
 Count existing data objects
 
 @param params Count data objects parameters
 
 @return Reponse to existing data object count request
 */
- (SyncanoResponse_DataObjects_Count *)dataCount:(SyncanoParameters_DataObjects_Count *)params;

#pragma mark - Asynchronized

///-
/// @name Asynchronous requests
///-

/**
 Create new data object
 
 @param params Parameters of new data object
 */
- (void)dataNew:(SyncanoParameters_DataObjects_New *)params callback:(void (^)(SyncanoResponse_DataObjects_New *response))callback;
/**
 Get data object list
 
 @param params Data object list parameters
 */
- (void)dataGet:(SyncanoParameters_DataObjects_Get *)params callback:(void (^)(SyncanoResponse_DataObjects_Get *response))callback;
/**
 Get one data object
 
 @param params Single data object getter parameters
 */
- (void)dataGetOne:(SyncanoParameters_DataObjects_GetOne *)params callback:(void (^)(SyncanoResponse_DataObjects_GetOne *response))callback;
/**
 Update existing data object
 
 @param params Update data object parameters
 */
- (void)dataUpdate:(SyncanoParameters_DataObjects_Update *)params callback:(void (^)(SyncanoResponse_DataObjects_Update *response))callback;
/**
 Move existing data object
 
 @param params Move data object parameters
 */
- (void)dataMove:(SyncanoParameters_DataObjects_Move *)params callback:(void (^)(SyncanoResponse *response))callback;
/**
 Copy existing data object
 
 @param params Copy data object parameters
 */
- (void)dataCopy:(SyncanoParameters_DataObjects_Copy *)params callback:(void (^)(SyncanoResponse_DataObjects_Copy *response))callback;
/**
 Add parent to existing data object
 
 @param params Add parent to data object parameters
 */
- (void)dataAddParent:(SyncanoParameters_DataObjects_AddParent *)params callback:(void (^)(SyncanoResponse *response))callback;
/**
 Remove parent to existing data object
 
 @param params Remove parent to data object parameters
 */
- (void)dataRemoveParent:(SyncanoParameters_DataObjects_RemoveParent *)params callback:(void (^)(SyncanoResponse *response))callback;
/**
 Delete existing data object
 
 @param params Delete data object parameters
 */
- (void)dataDelete:(SyncanoParameters_DataObjects_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;
/**
 Count existing data objects
 
 @param params Count data objects parameters
 */
- (void)dataCount:(SyncanoParameters_DataObjects_Count *)params callback:(void (^)(SyncanoResponse_DataObjects_Count *response))callback;

@end

#endif
