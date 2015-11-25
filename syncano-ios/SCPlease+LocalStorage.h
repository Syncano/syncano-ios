//
//  SCPlease+LocalStorage.h
//  syncano-ios
//
//  Created by Jan Lipmann on 20/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCPlease.h"

@interface SCPlease (LocalStorage)
- (void)giveMeDataObjectsFromLocalStorageWithPredicate:(id<SCPredicateProtocol>)predicate completion:(SCDataObjectsCompletionBlock)completion;
@end
