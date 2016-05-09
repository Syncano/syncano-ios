//
//  SCPredicate.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 15/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPredicateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Operators definitions
 */
extern NSString *const SCPredicateGreaterThanOperator;
extern NSString *const SCPredicateGreaterThanOrEqualOperator;
extern NSString *const SCPredicateLessThanOperator;
extern NSString *const SCPredicateLessThanOrEqualOperator;
extern NSString *const SCPredicateEqualOperator;
extern NSString *const SCPredicateNotEqualOperator;
extern NSString *const SCPredicateExistsOperator;
extern NSString *const SCPredicateInOperator;
extern NSString *const SCPredicateStringStartsWithOperator;
extern NSString *const SCPredicateStringiStartsWithOperator;
extern NSString *const SCPredicateStringEndsWithOperator;
extern NSString *const SCPredicateStringiEndsWithOperator;
extern NSString *const SCPredicateStringContainsOperator;
extern NSString *const SCPredicateStringiContainsOperator;
extern NSString *const SCPredicateStringiEqualOperator;
extern NSString *const SCPredicateIsOperator;

/**
 *  Class
 */
@interface SCPredicate : NSObject <SCPredicateProtocol>

/**
 *  Key, e.g. "id"
 */
@property (nullable,nonatomic,retain) NSString *leftHand;
/**
 *  Compare operator, e.g. "SCPredicateEqualOperator"
 */
@property (nullable,nonatomic,retain) NSString *operator;
/**
 *  Value, e.g. "23"
 */
@property (nullable,nonatomic,retain) id rightHand;

/**
 *  Returns predicate where key is greater than provided string
 *
 *  @param key    key
 *  @param string provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanString:(NSString *)string;

/**
 *  Returns predicate where key is greater than provided number
 *
 *  @param key    key
 *  @param number provided NSNumber
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanNumber:(NSNumber *)number;

/**
 *  Returns predicate where key is greater than provided date
 *
 *  @param key  key
 *  @param date provided NSDate
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanDate:(NSDate *)date;

/**
 *  Returns predicate where key is greater than or equal to provided string
 *
 *  @param key    key
 *  @param string provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToString:(NSString *)string;

/**
 *  Returns predicate where key is greater than or equal to provided number
 *
 *  @param key    key
 *  @param number provided NSNumber
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToNumber:(NSNumber *)number;

/**
 *  Returns predicate where key is greater than or equal to provided date
 *
 *  @param key  key
 *  @param date provided NSDate
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToDate:(NSDate *)date;

/**
 *  Returns predicate where key is less than provided string
 *
 *  @param key    key
 *  @param string provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isLessThanString:(NSString *)string;

/**
 *  Returns predicate where key is less than provided number
 *
 *  @param key    key
 *  @param number provided NSNumber
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isLessThanNumber:(NSNumber *)number;

/**
 *  Returns predicate where key is less than provided date
 *
 *  @param key  key
 *  @param date provided NSDate
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isLessThanDate:(NSDate *)date;

/**
 *  Returns predicate where key is less than or equal to provided string
 *
 *  @param key    key
 *  @param string provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToString:(NSString *)string;

/**
 *  Returns predicate where key is less than or equal to provided number
 *
 *  @param key    key
 *  @param number provided NSNumber
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToNumber:(NSNumber *)number;

/**
 *  Returns predicate where key is less than or equal to provided date
 *
 *  @param key  key
 *  @param date provided NSDate
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToDate:(NSDate *)date;

/**
 *  Returns predicate where key is equal to provided string
 *
 *  @param key    key
 *  @param string provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isEqualToString:(NSString *)string;

/**
 *  Returns predicate where key is equal to provided number
 *
 *  @param key    key
 *  @param number provided NSNumber
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isEqualToNumber:(NSNumber *)number;

/**
 *  Returns predicate where key is equal to provided boolean
 *
 *  @param key    key
 *  @param number provided BOOL
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isEqualToBool:(BOOL)boolValue;

/**
 *  Returns predicate where key is equal to provided date
 *
 *  @param key  key
 *  @param date provided NSDate
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key isEqualToDate:(NSDate *)date;

/**
 *  Returns predicate where key is not equal to provided string
 *
 *  @param key    key
 *  @param string provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key notEqualToString:(NSString *)string;

/**
 *  Returns predicate where key is not equal to provided number
 *
 *  @param key    key
 *  @param number provided NSNumber
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key notEqualToNumber:(NSNumber *)number;

/**
 *  Returns predicate where key is not equal to provided boolean
 *
 *  @param key    key
 *  @param number provided BOOL
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key notEqualToBool:(BOOL)boolValue;

/**
 *  Returns predicate where key is not equal to provided date
 *
 *  @param key  key
 *  @param date provided NSDate
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key notEqualToDate:(NSDate *)date;

/**
 *  Returns predicate where key exists
 *
 *  @param key key
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKeyExists:(NSString *)key;

/**
 *  Returns predicate where key does not exist
 *
 *  @param key key
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKeyDoesNotExist:(NSString *)key;

/**
 *  Returns predicate where key is contained in provided array
 *
 *  @param key   key
 *  @param array provided NSArray
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key inArray:(NSArray *)array;

/**
 *  Returns predicate where key satisfies another predicate
 *
 *  @param key       key
 *  @param predicate provided SCPredicate
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key satisfiesPredicate:(id<SCPredicateProtocol>)predicate;

/**
 *  Returns predicate where key has provided prefix
 *
 *  @param key    key
 *  @param prefix provided NSString prefix
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key hasPrefix:(NSString *)prefix;

/**
 *  Returns predicate where key has provided case insensitive prefix
 *
 *  @param key    key
 *  @param prefix provided NSString prefix
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveHasPrefix:(NSString *)prefix;

/**
 *  Returns predicate where key has provided sufix
 *
 *  @param key    key
 *  @param prefix provided NSString suffix
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key hasSuffix:(NSString *)suffix;

/**
 *  Returns predicate where key has provided case insensitive suffix
 *
 *  @param key    key
 *  @param prefix provided NSString sufix
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveHasSuffix:(NSString *)suffix;

/**
 *  Returns predicate where key contains provided string
 *
 *  @param key    key
 *  @param prefix provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key containsString:(NSString *)string;

/**
 *  Returns predicate where key contains provided case insensitive string
 *
 *  @param key    key
 *  @param prefix provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveContainsString:(NSString *)string;

/**
 *  Returns predicate where key is equalt to provided case insensitive string
 *
 *  @param key    key
 *  @param prefix provided NSString
 *
 *  @return SCPredicate
 */
+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveIsEqualToString:(NSString *)string;

@end
NS_ASSUME_NONNULL_END