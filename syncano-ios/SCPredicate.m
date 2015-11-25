//
//
//  syncano4-ios
//
//  Created by Jan Lipmann on 15/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCPredicate.h"

NSString *const SCPredicateGreaterThanOperator = @"_gt";
NSString *const SCPredicateGreaterThanOrEqualOperator = @"_gte";
NSString *const SCPredicateLessThanOperator = @"_lt";
NSString *const SCPredicateLessThanOrEqualOperator = @"_lte";
NSString *const SCPredicateEqualOperator = @"_eq";
NSString *const SCPredicateNotEqualOperator = @"_neq";
NSString *const SCPredicateExistsOperator = @"_exists";
NSString *const SCPredicateInOperator = @"_in";

static NSDateFormatter *dateFormatter;

@interface SCPredicate ()

@end

@implementation SCPredicate {
    NSString *_leftHand;
    NSString *_operator;
    id _rightHand;
}

- (instancetype)initWithLeftHand:(NSString *)leftHand operator:(NSString *)operator rightHand:(id)rightHand {
    self = [super init];
    if (self) {
        _leftHand = leftHand;
        _operator = operator;
        _rightHand = rightHand;
    }
    return self;
}

- (NSString *)leftHand {
    return _leftHand;
}

- (id)rightHand {
    return _rightHand;
}

- (NSString *)operator {
    return _operator;
}

- (NSString *)queryRepresentation {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{self.leftHand : @{self.operator : self.rightHand}}
                                                       options:0
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSDateFormatter *)dateFormatter {
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    }
    return dateFormatter;
}

+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanDate:(NSDate *)date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOrEqualOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOrEqualOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToDate:(NSDate *)date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOrEqualOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key isLessThanString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanDate:(NSDate *)date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOrEqualOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOrEqualOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToDate:(NSDate *)date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOrEqualOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key isEqualToString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateEqualOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isEqualToNumber:(NSNumber *)number {
   return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateEqualOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isEqualToBool:(BOOL)boolValue {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateEqualOperator rightHand:@(boolValue)];
}
+ (SCPredicate *)whereKey:(NSString *)key isEqualToDate:(NSDate *)date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateEqualOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key notEqualToString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateNotEqualOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key notEqualToNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateNotEqualOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key notEqualToBool:(BOOL)boolValue {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateNotEqualOperator rightHand:@(boolValue)];
}
+ (SCPredicate *)whereKey:(NSString *)key notEqualToDate:(NSDate *)date {
    NSString *dateString = [[self dateFormatter] stringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateNotEqualOperator rightHand:dateString];
}

+ (SCPredicate *)whereKeyExists:(NSString *)key {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateExistsOperator rightHand:@(YES)];
}

+ (SCPredicate *)whereKey:(NSString *)key inArray:(NSArray *)array {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateInOperator rightHand:array];
}

@end
