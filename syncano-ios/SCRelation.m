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
#import "NSObject+SCParseHelper.h"


@interface SCRelation ()
@property (nonatomic,retain) NSArray *membersIds;
@end

@implementation SCRelation

+ (SCRelation *)relationWithTargetClass:(Class)targetClass {
    SCRelation *relation = [[[self class] alloc] initWithTargetClass:targetClass];
    return relation;
}

- (instancetype)initWithTargetClass:(Class)targetClass {
    self = [super init];
    if (self) {
        self.targetClass = targetClass;
    }
    return self;
}

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error targetClass:(Class)targetClass {
    self = [super init];
    if (self) {
        self.membersIds = [[dictionaryValue[@"value"] sc_arrayOrNil] mutableCopy];
        self.targetClass = targetClass;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.membersIds = [NSMutableArray new];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

- (BOOL)isKindOfTargetClass:(SCDataObject *)member {
    return [member class] == self.targetClass;
}

- (SCPlease *)please {
    SCPleaseForRelation *please = [SCPleaseForRelation pleaseInstanceForDataObjectWithClass:self.targetClass withRelationWithMembers:self.membersIds];
    return please;
}

- (SCPlease *)pleaseForSyncano:(Syncano *)syncano {
    SCPleaseForRelation *please = [SCPleaseForRelation pleaseInstanceForDataObjectWithClass:self.targetClass forSyncano:syncano withRelationWithMembers:self.membersIds];
    return please;
}

- (void)setMembers:(NSArray<SCDataObject *>*)members {
    NSMutableArray *_members = [NSMutableArray new];
    for (SCDataObject* dataObject in members) {
        if (dataObject.objectId != nil) {
            [_members addObject:dataObject.objectId];
        }
    }
    _membersIds = [NSArray arrayWithArray:_members];
}
@end

@implementation SCRelation (Representations)
- (NSArray *)arrayRepresentation {
    return [NSArray arrayWithArray:self.membersIds];
}
@end
