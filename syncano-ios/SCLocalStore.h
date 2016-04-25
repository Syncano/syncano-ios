//
//  SCOfflineStore.h
//  syncano-ios
//
//  Created by Jan Lipmann on 08/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class SCDataObject;

NS_ASSUME_NONNULL_BEGIN

@interface SCLocalStore : NSObject
/**
 *  Initializes database
 *
 *  @param completionBlock completion block
 */
- (void)initializeDBWithCompletionBlock:(nullable SCCompletionBlock)completionBlock;

/**
 *  Attempts to save SCDataObject into local database
 *
 *  @param dataObject      SCDataObject
 *  @param completionBlock completion block
 */
- (void)saveDataObject:(SCDataObject *)dataObject withCompletionBlock:(nullable SCCompletionBlock)completionBlock;

/**
 *  Fetches all data objects of provided class from local database
 *
 *  @param objectClass     Class
 *  @param completionBlock completion block
 */
- (void)fetchAllObjectsOfClass:(Class)objectClass withCompletionBlock:(nullable SCDataObjectsCompletionBlock)completionBlock;

/**
 *  Deletes data object from local database
 *
 *  @param dataObject      SCDataObject to delete
 *  @param completionBlock completion block
 */
- (void)deleteDataObject:(SCDataObject *)dataObject withCompletionBlock:(nullable SCCompletionBlock)completionBlock;
@end
NS_ASSUME_NONNULL_END