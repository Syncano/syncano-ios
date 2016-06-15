//
//  SCPleaseForRelation.m
//  syncano-ios
//
//  Created by Jan Lipmann on 09/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPleaseForRelation.h"
#import "Syncano.h"
#import "SCAPIClient+SCDataObject.h"
#import "SCPleaseProtected.h"
#import "SCCompoundPredicate.h"

@interface SCPleaseForRelation ()
@property (nonatomic,assign) NSArray *relationMembers;
@end

@implementation SCPleaseForRelation

+ (SCPleaseForRelation *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass withRelationWithMembers:(NSArray *)members {
    SCPleaseForRelation *please = [[SCPleaseForRelation alloc] initWithDataObjectClass:dataObjectClass relationMembers:members];
    return please;
}

+ (SCPleaseForRelation *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forSyncano:(Syncano *)syncano withRelationWithMembers:(NSArray *)members {
    SCPleaseForRelation *please = [[SCPleaseForRelation alloc] initWithDataObjectClass:dataObjectClass relationMembers:members];
    please.syncano = syncano;
    return please;
}

- (instancetype)initWithDataObjectClass:(Class)dataObjectClass relationMembers:(NSArray *)members {
    self = [super initWithDataObjectClass:dataObjectClass];
    if (self) {
        self.relationMembers = members;
    }
    return self;
}

- (void)setPredicate:(id<SCPredicateProtocol>)predicate {
    SCPredicate *membersPredicate = [SCPredicate whereKey:@"id" inArray:_relationMembers];
    SCCompoundPredicate *compoundPredicate;
    if (predicate) {
        if ([predicate isKindOfClass:[SCCompoundPredicate class]]) {
            compoundPredicate = (SCCompoundPredicate *)predicate;
            [compoundPredicate addPredicate:membersPredicate];
        } else {
            compoundPredicate = [SCCompoundPredicate compoundPredicateWithPredicates:@[predicate,membersPredicate]];
        }
        [super setPredicate:compoundPredicate];
    } else {
        [super setPredicate:membersPredicate];
    }
}

@end
