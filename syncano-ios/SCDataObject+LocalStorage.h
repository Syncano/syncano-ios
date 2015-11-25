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


+ (void)fetchAllObjectsFromLocalStorageWithCompletionBlock:(SCDataObjectsCompletionBlock)completionBlock;

#pragma mark - Helpers -
- (void)generateInsertQueryWithCompletion:(void(^)(NSError *error, NSString* query))completion;
@end
