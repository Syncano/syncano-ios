//
//  SyncanoProtocolFolders.h
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#ifndef Syncano_SyncanoProtocolFolders_h
#define Syncano_SyncanoProtocolFolders_h

#import "SyncanoParameters_Folders.h"
#import "SyncanoResponse_Folders.h"

/**
 SyncanoProtocolFolders is used to transmit information about SyncanoFolder objects
 
 @note All `SyncanoProtocol*` protocols define method signatures used by objects (i.e. Syncano, SyncanoSyncServer communicating with Syncano API.
 */
@protocol SyncanoProtocolFolders <NSObject>
@required

#pragma mark - Synchronized

- (SyncanoResponse_Folders_New *)folderNew:(SyncanoParameters_Folders_New *)params;
- (SyncanoResponse_Folders_Get *)folderGet:(SyncanoParameters_Folders_Get *)params;
- (SyncanoResponse_Folders_GetOne *)folderGetOne:(SyncanoParameters_Folders_GetOne *)params;
- (SyncanoResponse *)folderUpdate:(SyncanoParameters_Folders_Update *)params;
- (SyncanoResponse *)folderDelete:(SyncanoParameters_Folders_Delete *)params;

#pragma mark - Asynchronized

///-
/// @name Synchronous requests
///-

/**
 Create new folder
 
 @param params Parameters of new folder
 */
- (void)folderNew:(SyncanoParameters_Folders_New *)params callback:(void (^)(SyncanoResponse_Folders_New *response))callback;
/**
 Get folder list
 
 @param params Folder list parameters
 */
- (void)folderGet:(SyncanoParameters_Folders_Get *)params callback:(void (^)(SyncanoResponse_Folders_Get *response))callback;
/**
 Get one folder
 
 @param params Single folder getter parameters
 */
- (void)folderGetOne:(SyncanoParameters_Folders_GetOne *)params callback:(void (^)(SyncanoResponse_Folders_GetOne *response))callback;
/**
 Update existing folder
 
 @param params Update folder parameters
 */
- (void)folderUpdate:(SyncanoParameters_Folders_Update *)params callback:(void (^)(SyncanoResponse *response))callback;
/**
 Delete existing folder
 
 @param params Delete folder parameters
 */
- (void)folderDelete:(SyncanoParameters_Folders_Delete *)params callback:(void (^)(SyncanoResponse *response))callback;

@end

#endif
