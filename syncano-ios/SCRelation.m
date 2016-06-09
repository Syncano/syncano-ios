//
//  SCRelation.m
//  syncano-ios
//
//  Created by Jan Lipmann on 09/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCRelation.h"
#import "SCDataObject.h"


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
