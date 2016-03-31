//
//  SCReferenceStore.h
//  syncano-ios
//  Class used to store weak references to parsed object for future use by SCParseManager to attach relations
//
//  Created by Jan Lipmann on 03/03/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCDataObject;

@interface SCReferencesStore : NSObject
/**
 *  Adds SCDataObject weak reference to SCRefrencesStore
 *
 *  @param dataObject SCDataObject to add
 */
- (void)addDataObject:(SCDataObject *)dataObject;

/**
 *  Finds object by it's id
 *
 *  @param objectId NSNumber with object id
 *
 *  @return SCDataObject found or nil
 */
- (SCDataObject *)getObjectById:(NSNumber *)objectId;
@end
