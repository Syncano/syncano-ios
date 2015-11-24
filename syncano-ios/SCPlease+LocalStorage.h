//
//  SCPlease+LocalStorage.h
//  syncano-ios
//
//  Created by Jan Lipmann on 20/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCPlease.h"
#import "SCLocalStoragePredicateProtocol.h"

@interface SCPlease (LocalStorage)
- (void)giveMeDataObjectsFromLocalStorageWithPredicate:(id<SCLocalStoragePredicateProtocol>)predicate completion:(SCDataObjectsCompletionBlock)completion;
@end
