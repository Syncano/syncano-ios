//
//  SyncanoParameters_Projects.h
//  Syncano
//
//  Created by Syncano Inc. on 03/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters.h"

/**
 Create a new project params
 */
@interface SyncanoParameters_Projects_New : SyncanoParameters
/**
 New project's name.
 */
@property (strong)  NSString *name;
/**
 New project's description
 */
@property (strong)  NSString *description;
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_New *)initWithName:(NSString *)name;
/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_New *)initWithName:(NSString *)name description:(NSString*)description;

@end

/**
 Get projects.
 */
@interface SyncanoParameters_Projects_Get : SyncanoParameters
@end

/**
 Get one project
 */
@interface SyncanoParameters_Projects_GetOne : SyncanoParameters
/**
 Project ID
 */
@property (strong)    NSString *projectId;

/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_GetOne *)initWithProjectId:(NSString *)projectId;

@end

/**
 Update existing project
 */
@interface SyncanoParameters_Projects_Update : SyncanoParameters

- (SyncanoParameters_Projects_Update *)initWithProjectId:(NSString *)projectId;
/**
 Existing project's id.
 */
@property (strong)  NSString *projectId;
/**
 New name of specified project.
 */
@property (strong)  NSString *name;
/**
 New description of specified project.
 */
@property (strong)  NSString *description;

@end

/**
 Delete (permanently) project with specified project_id.
 */
@interface SyncanoParameters_Projects_Delete : SyncanoParameters

/**
 @return SyncanoParameters object with required fields initialized
 */
- (SyncanoParameters_Projects_Delete *)initWithProjectId:(NSString *)projectId;
/**
 Project id defining project to be deleted.
 */
@property (strong)    NSString *projectId;

@end
