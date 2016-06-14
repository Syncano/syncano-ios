//
//  SCRelation.h
//  syncano-ios
//
//  Created by Jan Lipmann on 09/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "SCConstants.h"


@class SCDataObject,Syncano,SCPlease;

NS_ASSUME_NONNULL_BEGIN

@interface SCRelation : MTLModel<MTLJSONSerializing>

@property (nullable, nonatomic, copy) NSString *targetClassName;

+ (SCRelation *)relationWithTargetClassName:(NSString *)targetClassName;

- (instancetype)initWithTargetClassName:(NSString *)targetClassName;

-(instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error targetClassName:(NSString *)targetClassName;

- (SCPlease *)please;

- (SCPlease *)pleaseForSyncano:(Syncano *)syncano;

- (void)setMembers:(NSArray<SCDataObject *>*)members;

@end

@interface SCRelation (Representations)
- (NSArray *)arrayRepresentation;
@end

NS_ASSUME_NONNULL_END
