//
//  SCDataObject+LocalStorage.h
//  syncano-ios
//
//  Created by Jan Lipmann on 28/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCDataObject.h"

@interface SCDataObject (LocalStorage)

#pragma mark - Saving -
/**
 *  Attempts to save SCDataObject into local database
 *
 *  @param completionBlock completion block
 */
- (void)saveToLocalStorageWithCompletion:(nullable SCCompletionBlock)completion;

#pragma mark - Fetch -
/**
 *  Fetches all data objects from local database
 *
 *  @param completionBlock completion block
 */
+ (void)fetchAllObjectsFromLocalStorageWithCompletionBlock:(nullable SCDataObjectsCompletionBlock)completionBlock;

#pragma mark - Delete -
/**
 *  Deletes data object from local database
 *
 *  @param completionBlock completion block
 */
- (void)deleteFromLocalStorageWithCompletion:(nullable SCCompletionBlock)completion;

#pragma mark - Helpers -

/**
 *  Generates INSERT query for current SCDataObject
 *
 *  @param completion completion block
 */
- (void)generateInsertQueryWithCompletion:(nullable SCLocalStorageGenerateQueryStringCompletionBlock)completion;

/**
 *  Generates DELETE query for current SCDataObject
 *
 *  @param completion completion block
 */
- (void)generateDeleteQueryWithCompletion:(nullable SCLocalStorageGenerateQueryStringCompletionBlock)completion;
@end
