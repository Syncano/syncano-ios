//
//  SCRelation.m
//  syncano-ios
//
//  Created by Jan Lipmann on 09/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCRelation.h"
#import "Syncano.h"
#import "SCPlease.h"
#import "SCPredicate.h"
#import "SCPleaseForRelation.h"


@interface SCRelation ()
@property (nonatomic,retain) NSMutableArray *membersIds;
@end

@implementation SCRelation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.membersIds = [NSMutableArray new];
    }
    return self;
}

- (BOOL)isKindOfTargetClass:(SCDataObject *)member {
    return [NSStringFromClass([member class]) isEqualToString:self.targetClassName];
}

- (SCPlease *)please {
    SCPleaseForRelation *please = [SCPleaseForRelation pleaseInstanceForDataObjectWithClass:NSClassFromString(self.targetClassName) withRelationWithMembers:self.membersIds];
    return please;
}

- (SCPlease *)pleaseForSyncano:(Syncano *)syncano {
    SCPleaseForRelation *please = [SCPleaseForRelation pleaseInstanceForDataObjectWithClass:NSClassFromString(self.targetClassName) forSyncano:syncano withRelationWithMembers:self.membersIds];
    return please;
}

- (void)addDataObject:(SCDataObject *)object {
    if (![self isKindOfTargetClass:object]) {
        return;
    }
    NSNumber *objectId = object.objectId;
    if ([self.membersIds containsObject:objectId]) {
        return;
    }
    [self.membersIds addObject:objectId];
}

- (void)removeDataObject:(SCDataObject *)object {
    if (![self isKindOfTargetClass:object]) {
        return;
    }
    NSNumber *objectId = object.objectId;
    if (![self.membersIds containsObject:objectId]) {
        return;
    }
    [self.membersIds removeObject:objectId];
}

@end
