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
#import "SCPredicate+LocalStorage.h"
#import "SCCompoundPredicate+LocalStorage.h"

@implementation SCPlease (LocalStorage)

- (void)giveMeDataObjectsFromLocalStorageWithCompletion:(SCDataObjectsCompletionBlock)completion {
    [self giveMeDataObjectsFromLocalStorageWithPredicate:nil completion:completion];
}

- (void)giveMeDataObjectsFromLocalStorageWithPredicate:(id<SCPredicateProtocol>)predicate completion:(SCDataObjectsCompletionBlock)completion {
    if (predicate && ![predicate respondsToSelector:@selector(nspredicateRepresentation)]) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"SCPleaseErrorDomain" code:1 userInfo:@{@"SyncanoError":@"Predicate has to respond to 'nspredicateRepresentation' method"}];
            completion(nil,error);
        }
        return;
    }
    
    [[Syncano localStore] fetchAllObjectsOfClass:self.dataObjectClass withCompletionBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil,error);
            }
        } else {
            if (completion) {
                if (predicate) {
                    NSPredicate *_predicate = [predicate nspredicateRepresentation];
                    objects = [objects filteredArrayUsingPredicate:_predicate];
                }
                completion(objects,nil);
            }
        }
    }];
    
}
@end
