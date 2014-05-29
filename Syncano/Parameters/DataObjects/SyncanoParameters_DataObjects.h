//
//  SyncanoParameters_DataObjects.h
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

extern NSString *const kSyncanoParametersDataObjectsStatePending;
extern NSString *const kSyncanoParametersDataObjectsStateModerated;
extern NSString *const kSyncanoParametersDataObjectsStateRejected;

/**
   Parameters for data object validation
 */
@interface SyncanoParameters_DataObjects_State_Validate : SyncanoParameters
/**
   State of data to be initially set. Accepted values: Pending, Moderated, Rejected. Default value: Pending.
 */
@property (strong, nonatomic)    NSString *state;
@end

/**
   Parameters for validation
 */
@interface SyncanoParameters_ProjectId_CollectionId_CollectionKey_State_Validate : SyncanoParameters_ProjectId_CollectionId_CollectionKey
/**
   State of data to be initially set. Accepted values: Pending, Moderated, Rejected. Default value: Pending.
 */
@property (strong, nonatomic)    NSString *state;
@end

/**
   Parameters for validation
 */
@interface SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State : SyncanoParameters_DataObjects_State_Validate

@property (strong)    NSString *projectId;
@property (strong)    NSString *collectionId;
@property (strong)    NSString *collectionKey;
@property (strong)    NSString *dataId;
@property (strong)    NSString *dataKey;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId state:(NSString *)state;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataKey:(NSString *)dataKey state:(NSString *)state;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId state:(NSString *)state;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataKey:(NSString *)dataKey state:(NSString *)state;

@end

/**
   Parameters for data object creation
 */
@interface SyncanoParameters_DataObjects_New : SyncanoParameters_ProjectId_CollectionId_CollectionKey_State_Validate
/**
   Used for uniquely identifying message. Has to be unique within collection. Useful for updating
 */
@property (strong)  NSString *dataKey;
/**
   User name of user to associate Data Object with. If not set, internal user 'syncano' is used
 */
@property (strong)  NSString *userName;
/**
   Source URL associated with message
 */
@property (strong)  NSString *sourceUrl;
/**
   Title of message
 */
@property (strong)  NSString *title;
/**
   Text data associated with message
 */
@property (strong)  NSString *text;
/**
   Link associated with message
 */
@property (strong)  NSString *link;
/**
   Image data associated with message
 */
@property (strong)  UIImage *image;
/**
   Image data associated with message
 */
@property (strong)  NSString *imageUrl;
/**
   Folder name that data will be put in. Default value: 'Default'
 */
@property (strong)  NSString *folder;
/**
   State of data to be initially set. Accepted values: Pending, Moderated, Rejected. Default value: Pending.
 */
@property (strong)  NSString *parentId;
/**
   Any number of additional parameters given in this dictionary will be saved into an additional structure.
 */
@property (strong)  NSDictionary *additional;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_New *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId state:(NSString *)state;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_New *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey state:(NSString *)state;

@end

/**
   Get data from collection(s) or whole project with optional additional filtering. All filters, unless explicitly noted otherwise, affect all hierarchy levels. To paginate and to get more data, use since_id or since_time parameter.
 */
@interface SyncanoParameters_DataObjects_Get : SyncanoParameters_ProjectId_CollectionId_CollectionKey
/**
   If specified, will return data objects with specified ids. Note: has no effect on returned data object's children. Max 100 values per request.
 */
@property (strong)    NSArray *dataIds;
/**
   State of data to be returned. Accepted values: Pending, Moderated, All. Default value: All.
 */
@property (strong, nonatomic)    NSString *state;
/**
   Folder name that data will be returned from. Max 100 values per request. If not present, returns data from all collection folders.
 */
@property (strong)    NSArray *folders;
/**
   If specified, will only return data with an id higher than since_id (newer). Note: has no effect on returned data objects children.
 */
@property (strong)    NSString *sinceId;
/**
   String with date. If specified, will only return data with a created_at or updated_at time after specified value (newer). Note: has no effect on returned data object's children.
 */
@property (strong)    NSDate *sinceTime;
/**
   If specified, will only return data with id lower than max_id (older).
 */
@property (strong)    NSString *maxId;
/**
   Number of Data Objects to be returned. Default and max value: 100.
 */
@property (strong)    NSNumber *limit;
/**
   If true, include Data Object children as well (recursively). Default value: True. Max 100 of children are shown in one request.
 */
@property (strong)    NSNumber *includeChildren;
/**
   Max depth of children to follow. If not specified, will follow all levels until children limit is reached.
 */
@property (strong)    NSNumber *depth;
/**
   Limit of children to show (if include_children is True). Default and max value: 100 (some children levels may be incomplete if there are more than this limit).
 */
@property (strong)    NSNumber *childrenLimit;
/**
   Data Object id or ids. If specified, only children of specific Data Object parent will be listed.
 */
@property (strong)    NSArray *parentIds;
/**
   If specified, filter by Data Object user's name.
 */
@property (strong)    NSString *byUser;
/**
   Sets order of data that will be returned. Possible values:

   - ASC (default) - oldest first,
   - DESC - newest first.
 */
@property (strong, nonatomic)    NSString *order;
/**
   Orders by specified criteria. Possible values:

   - created_at (default) - order by creation date,
   - updated_at - order by update date.
 */
@property (strong, nonatomic)    NSString *orderBy;
/**
   Filtering by content. Possible values:

   - TEXT - only data with text field specified,
   - IMAGE - only data with an image attached.
 */
@property (strong, nonatomic)    NSString *filter;

@end

/**
   Get data by data_id or data_key.

   Either data_id or data_key has to be specified.

   The collection_id/collection_key parameter means that one can use either one of them - collection_id or collection_key.
 */
@interface SyncanoParameters_DataObjects_GetOne : SyncanoParameters
/**
   Project id
 */
@property (strong) NSString *projectId;
/**
   Collection id defining a collection for which data will be returned.
 */
@property (strong) NSString *collectionId;
/**
   Collection key defining a collection for which data will be returned.
 */
@property (strong) NSString *collectionKey;
/**
   Data Object's id.
 */
@property (strong) NSString *dataId;
/**
   Data Object's key.
 */
@property (strong) NSString *dataKey;
/**
   If true, include Data Object children as well (recursively). Default value: False. Max 100 of children are shown in one request.
 */
@property (strong) NSNumber *includeChildren;
/**
   Max depth of children to follow. If not specified, will follow all levels until children limit is reached.
 */
@property (strong) NSNumber *depth;
/**
   Limit of children to show (if include_children is True). Default and max value: 100 (some children levels may be incomplete if there are more than this limit).
 */
@property (strong) NSNumber *childrenLimit;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataKey:(NSString *)dataKey;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_GetOne *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataKey:(NSString *)dataKey;

@end

/**
   Updates an existing Data Object if data with a specified data_id or data_key already exists.
 */
@interface SyncanoParameters_DataObjects_Update : SyncanoParameters_DataObjects_CollectionId_CollectionKey_DataId_DataKey_State
/**
   Default value: replace.
 */
@property (strong)    NSString *updateMethod;
/**
   User name of user to associate Data Object with. If not set, internal user 'syncano' is used.
 */
@property (strong)    NSString *userName;
/**
   Source URL associated with message.
 */
@property (strong)    NSString *sourceUrl;
/**
   Title of message.
 */
@property (strong)    NSString *title;
/**
   Text data associated with message.
 */
@property (strong)    NSString *text;
/**
   Link associated with message.
 */
@property (strong)    NSString *link;
/**
   Image data associated with message. If specified as empty string - will instead delete current image.
 */
@property (strong)    UIImage *image;
/**
   Image source URL. Used in combination with image parameter.
 */
@property (strong)    NSString *imageUrl;
/**
   Folder name that data will be put in. Default value: 'Default'.
 */
@property (strong)    NSString *folder;
/**
   If specified, new Data Object becomes a child of specified parent id. Note that all other parent-child relations for this Data Object are removed.
 */
@property (strong)    NSString *parentId;

/**
   Any number of additional parameters given in this dictionary will be saved into an additional structure.
 */
@property (strong)    NSDictionary *additional;

@end

/**
   Moves data to a folder and/or state.
 */
@interface SyncanoParameters_DataObjects_Move : SyncanoParameters_ProjectId_CollectionId_CollectionKey_State_Validate

/**
   If specified, will filter by Data id or ids. Max 100 ids per request.
 */
@property (strong)              NSArray *dataIds;
/**
   If specified, filter by specified folder or folders. Max 100 values per request.
 */
@property (strong)              NSArray *folders;
/**
   Filtering by content. Possible values:

   - vTEXT - only data with text,
   - IMAGE - only data with an image.
 */
@property (strong, nonatomic)   NSString *filter;
/**
   If specified, filter by user's name.
 */
@property (strong)              NSString *byUser;
/**
   Number of Data Objects to process. Default and max value: 100.
 */
@property (strong)              NSNumber *limit;
/**
   Destination folder where data will be moved. If not specified, leaves folder as is.
 */
@property (strong, nonatomic)   NSString *folderNew;
/**
   State to be set data for specified data. Accepted values: Pending, Moderated. If not specified, leaves state as is.
 */
@property (strong, nonatomic)   NSString *stateNew;

@end

/**
   Copy data to a folder and/or state.
 */
@interface SyncanoParameters_DataObjects_Copy : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id defining collection containing data.
 */
@property (strong)    NSString *collectionId;
/**
   Collection key defining collection containing data.
 */
@property (strong)    NSString *collectionKey;
/**
   Data id or ids.
 */
@property (strong)    NSArray *dataIds;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_Copy *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataIds:(NSArray *)dataIds;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_Copy *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataIds:(NSArray *)dataIds;

@end

/**
   Adds additional parent to data with specified data_id. If remove_other is True, all other parents of specified Data Object will be removed.
 */
@interface SyncanoParameters_DataObjects_AddParent : SyncanoParameters

/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id defining collection containing data.
 */
@property (strong)    NSString *collectionId;
/**
   Collection key defining collection containing data.
 */
@property (strong)    NSString *collectionKey;
/**
   Data Object id.
 */
@property (strong)    NSString *dataId;
/**
   Parent id to remove. If not specified, will remove all Data Object parents.
 */
@property (strong)    NSString *parentId;
/**
   If true, will remove all other parents. Default value: False.
 */
@property (strong)    NSNumber *removeOther;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_AddParent *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId parentId:(NSString *)parentId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_AddParent *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId parentId:(NSString *)parentId;

@end

/**
   Removes a parent (or parents) from data with specified data_id.
 */
@interface SyncanoParameters_DataObjects_RemoveParent : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id defining collection containing data.
 */
@property (strong)    NSString *collectionId;
/**
   Collection key defining collection containing data.
 */
@property (strong)    NSString *collectionKey;
/**
   Data Object id.
 */
@property (strong)    NSString *dataId;
/**
   Parent id to remove. If not specified, will remove all Data Object parents.
 */
@property (strong)    NSString *parentId;

/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_RemoveParent *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_RemoveParent *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId;

@end

/**
   Adds additional child to data with specified data_id. If remove_other is True, all other children of specified Data Object will be removed.

   Note: There is a limit of maximum 250 parents per Data Object, but there is no limit of children.
 */
@interface SyncanoParameters_DataObjects_AddChild : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id defining collection containing data.
 */
@property (strong)    NSString *collectionId;
/**
   Collection key defining collection containing data.
 */
@property (strong)    NSString *collectionKey;
/**
   Data Object id.
 */
@property (strong)    NSString *dataId;
/**
   Child id to add.
 */
@property (strong)    NSString *childId;
/**
   If true, will remove all other children. Default value: False.
 */
@property (strong)    NSNumber *removeOther;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_AddChild *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId childId:(NSString *)childId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_AddChild *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId childId:(NSString *)childId;

@end

/**
   Removes a child (or children) from data with specified data_id.
 */
@interface SyncanoParameters_DataObjects_RemoveChild : SyncanoParameters
/**
   Project id.
 */
@property (strong)    NSString *projectId;
/**
   Collection id defining collection containing data.
 */
@property (strong)    NSString *collectionId;
/**
   Collection key defining collection containing data.
 */
@property (strong)    NSString *collectionKey;
/**
   data_id
 */
@property (strong)    NSString *dataId;
/**
   Parent id to remove. If not specified, will remove all Data Object children.
 */
@property (strong)    NSString *childId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_RemoveChild *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId dataId:(NSString *)dataId;
/**
   @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_DataObjects_RemoveChild *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey dataId:(NSString *)dataId;

@end

/**
   Deletes a Data Object. If no filters are specified, will process all Data Objects in defined collection(s) (up to defined limit).
 */
@interface SyncanoParameters_DataObjects_Delete : SyncanoParameters_ProjectId_CollectionId_CollectionKey_State_Validate

/**
   If specified, will filter by Data id or ids. Max 100 ids per request.
 */
@property (strong)    NSArray *dataIds;
/**
   If specified, filter by specified folder or folders. Max 100 values per request.
 */
@property (strong)    NSArray *folders;
/**
   If specified, filter by user name.
 */
@property (strong)    NSString *byUser;
/**
   Number of Data Objects to process. Default and max value: 100.
 */
@property (strong)    NSNumber *limit;
/**
   Filtering by content. Possible values:
   TEXT - only data with text,
   IMAGE - only data with an image.
 */
@property (strong, nonatomic)    NSString *filter;

@end

@interface SyncanoParameters_DataObjects_Count : SyncanoParameters_ProjectId_CollectionId_CollectionKey_State_Validate

/**
   Folder name(s) that data will be counted from. If not presents counts data from across all collection folders. Max 100 values per request.
 */
@property (strong)    NSArray *folders;
/**
   If specified, filter by user name.
 */
@property (strong)    NSString *byUser;
/**
   Filtering by content. Possible values:

   TEXT - only data with text,
   IMAGE - only data with an image.
 */
@property (strong, nonatomic)    NSString *filter;

@end
