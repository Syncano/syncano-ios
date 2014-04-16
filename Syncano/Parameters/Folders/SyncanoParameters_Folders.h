//
//  SyncanoParameters_Folders.h
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
 Common folder parameters
 */
@interface SyncanoParameters_Folders_Name : SyncanoParameters

/**
 Project id.
 */
@property (strong)    NSString *projectId;
/**
 Collection id or key defining collection where folder will be created.
 */
@property (strong)    NSString *collectionId;
/**
 Collection id or key defining collection where folder will be created.
 */
@property (strong)    NSString *collectionKey;
/**
 Folder name
 */
@property (strong)    NSString *name;

/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_Name*)initWithProjectId:(NSString*)projectId collectionId:(NSString*)collectionId name:(NSString*)name;
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_Name*)initWithProjectId:(NSString*)projectId collectionKey:(NSString*)collectionKey name:(NSString*)name;

@end

/**
 Create new folder within a specified collection.
 */
@interface SyncanoParameters_Folders_New : SyncanoParameters_Folders_Name

@end

/**
 Get folders for a specified collection.
 */
@interface SyncanoParameters_Folders_Get : SyncanoParameters_ProjectId_CollectionId_CollectionKey

@end

/**
 Get single folder for a specified collection
 */
@interface SyncanoParameters_Folders_GetOne : SyncanoParameters
/**
 Project id.
 */
@property (strong)    NSString *projectId;
/**
 Collection id or key defining a collection for which the folder will be returned.
 */
@property (strong)    NSString *collectionId;
/**
 Collection id or key defining a collection for which the folder will be returned.
 */
@property (strong)    NSString *collectionKey;
/**
 Folder name defining folder.
 */
@property (strong)    NSString *folderName;

/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_GetOne*)initWithProjectId:(NSString*)projectId collectionId:(NSString*)collectionId folderName:(NSString*)folderName;
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Folders_GetOne*)initWithProjectId:(NSString*)projectId collectionKey:(NSString*)collectionKey folderName:(NSString*)folderName;

@end

/**
 Update existing folder
 */
@interface SyncanoParameters_Folders_Update : SyncanoParameters_Folders_Name
/**
 Current folder name.
 */
@property (strong, nonatomic) NSString *name;
/**
 New source id, can be used for mapping folders to external source.
 */
@property (strong)            NSString *sourceId;

@end

/**
 Permanently delete specified folder and all associated data.
 */
@interface SyncanoParameters_Folders_Delete : SyncanoParameters_Folders_Name
@end
