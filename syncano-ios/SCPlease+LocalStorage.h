//
//  SCPlease+LocalStorage.h
//  syncano-ios
//
//  Created by Jan Lipmann on 20/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCPlease.h"

@interface SCPlease (LocalStorage)
/**
 *  Fetches SCDataObjects from local database
 *
 *  @param completion completion block
 */
- (void)giveMeDataObjectsFromLocalStorageWithCompletion:(nullable SCDataObjectsCompletionBlock)completion;

/**
 *  Fetches SCDataObjects from local database with SCPredicate
 *
 *  @param predicate  predicate object that conforms to SCPredicateProtocol
 *  @param completion completion block
 */
- (void)giveMeDataObjectsFromLocalStorageWithPredicate:(nonnull id<SCPredicateProtocol>)predicate completion:(nullable SCDataObjectsCompletionBlock)completion;
@end
