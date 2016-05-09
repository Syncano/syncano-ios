//
//  SCCoumpoundPredicate.h
//  syncano-ios
//
//  Created by Jan Lipmann on 19/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPredicateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCCompoundPredicate : NSObject <SCPredicateProtocol>

/**
 *  List of contained predicates
 */
@property (nullable,nonatomic,readonly) NSArray * predicates;

/**
 *  Returnes new compound predicate with provided array of predicates
 *
 *  @param predicates NSArray of SCPredicates
 *
 *  @return SCCompoundPredicate
 */
+ (instancetype)compoundPredicateWithPredicates:(NSArray *)predicates;

/**
 *  Initialize new compound predicate with provided array of predicates
 *
 *  @param predicates NSArray of SCPredicates
 *
 *  @return SCCompoundPredicate
 */
- (instancetype)initWithPredicates:(NSArray *)predicates;

/**
 *  Adds predicate to existing compound predicate
 *
 *  @param predicate SCPredicate to add
 */
- (void)addPredicate:(id<SCPredicateProtocol>)predicate;
@end
NS_ASSUME_NONNULL_END