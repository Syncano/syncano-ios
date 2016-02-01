//
//  SCPredicate.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 15/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPredicateProtocol.h"

extern NSString *const SCPredicateGreaterThanOperator;
extern NSString *const SCPredicateGreaterThanOrEqualOperator;
extern NSString *const SCPredicateLessThanOperator;
extern NSString *const SCPredicateLessThanOrEqualOperator;
extern NSString *const SCPredicateEqualOperator;
extern NSString *const SCPredicateNotEqualOperator;
extern NSString *const SCPredicateExistsOperator;
extern NSString *const SCPredicateInOperator;

/**
 *  Class
 */
@interface SCPredicate : NSObject <SCPredicateProtocol>

@property (nonatomic,readonly) NSString *leftHand;
@property (nonatomic,readonly) NSString *operator;
@property (nonatomic,readonly) id rightHand;



+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanNumber:(NSNumber *)number;
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanDate:(NSDate *)date;

+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToNumber:(NSNumber *)number;
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToDate:(NSDate *)date;

+ (SCPredicate *)whereKey:(NSString *)key isLessThanString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key isLessThanNumber:(NSNumber *)number;
+ (SCPredicate *)whereKey:(NSString *)key isLessThanDate:(NSDate *)date;

+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToNumber:(NSNumber *)number;
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToDate:(NSDate *)date;

+ (SCPredicate *)whereKey:(NSString *)key isEqualToString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key isEqualToNumber:(NSNumber *)number;
+ (SCPredicate *)whereKey:(NSString *)key isEqualToBool:(BOOL)boolValue;
+ (SCPredicate *)whereKey:(NSString *)key isEqualToDate:(NSDate *)date;

+ (SCPredicate *)whereKey:(NSString *)key notEqualToString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key notEqualToNumber:(NSNumber *)number;
+ (SCPredicate *)whereKey:(NSString *)key notEqualToBool:(BOOL)boolValue;
+ (SCPredicate *)whereKey:(NSString *)key notEqualToDate:(NSDate *)date;

+ (SCPredicate *)whereKeyExists:(NSString *)key;

+ (SCPredicate *)whereKey:(NSString *)key inArray:(NSArray *)array;

+ (SCPredicate *)whereKey:(NSString *)key satisfiesPredicate:(id<SCPredicateProtocol>)predicate;

+ (SCPredicate *)whereKey:(NSString *)key hasPrefix:(NSString *)prefix;
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveHasPrefix:(NSString *)prefix;
+ (SCPredicate *)whereKey:(NSString *)key hasSuffix:(NSString *)suffix;
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveHasSuffix:(NSString *)suffix;
+ (SCPredicate *)whereKey:(NSString *)key containsString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveContainsString:(NSString *)string;
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveIsEqualToString:(NSString *)string;

@end
