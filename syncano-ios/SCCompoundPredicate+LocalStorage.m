//
//  SCCompoundPredicate+LocalStorage.m
//  syncano-ios
//
//  Created by Jan Lipmann on 24/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCCompoundPredicate+LocalStorage.h"

@implementation SCCompoundPredicate (LocalStorage)
- (NSPredicate *)nspredicateRepresentation {
    NSMutableArray *subpredicates = [NSMutableArray new];
    for (id<SCPredicateProtocol>predicate in self.predicates) {
        if ([predicate respondsToSelector:@selector(nspredicateRepresentation)]) {
            [subpredicates addObject:[predicate nspredicateRepresentation]];
        }
    }
    NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    return compoundPredicate;
}
@end
