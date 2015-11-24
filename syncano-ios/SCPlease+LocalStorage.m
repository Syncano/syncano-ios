//
//  SCPlease+LocalStorage.m
//  syncano-ios
//
//  Created by Jan Lipmann on 20/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCPlease+LocalStorage.h"
#import "Syncano.h"
#import "SCLocalStore.h"

@implementation SCPlease (LocalStorage)
- (void)giveMeDataObjectsFromLocalStorageWithPredicate:(id<SCLocalStoragePredicateProtocol>)predicate completion:(SCDataObjectsCompletionBlock)completion {
    __block NSPredicate *_predicate = [predicate nspredicateRepresentation];
    [[Syncano localStore] fetchAllObjectsOfClass:self.dataObjectClass withCompletionBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil,error);
            }
        } else {
            if (completion) {
                completion([objects filteredArrayUsingPredicate:_predicate],nil);
            }
        }
    }];
}
@end
