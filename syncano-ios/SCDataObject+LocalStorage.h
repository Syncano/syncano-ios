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
- (void)saveToLocalStorageWithCompletion:(SCCompletionBlock)completion;

#pragma mark - Fetch -
+ (void)fetchAllObjectsFromLocalStorageWithCompletionBlock:(SCDataObjectsCompletionBlock)completionBlock;

#pragma mark - Delete -
- (void)deleteFromLocalStorageWithCompletion:(SCCompletionBlock)completion;

#pragma mark - Helpers -
- (void)generateInsertQueryWithCompletion:(SCLocalStorageGenerateQueryStringCompletionBlock)completion;
- (void)generateDeleteQueryWithCompletion:(SCLocalStorageGenerateQueryStringCompletionBlock)completion;
@end
