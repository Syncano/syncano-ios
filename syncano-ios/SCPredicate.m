//
//
//  syncano4-ios
//
//  Created by Jan Lipmann on 15/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCPredicate.h"
#import "SCConstants.h"

NSString *const SCPredicateGreaterThanOperator = @"_gt";
NSString *const SCPredicateGreaterThanOrEqualOperator = @"_gte";
NSString *const SCPredicateLessThanOperator = @"_lt";
NSString *const SCPredicateLessThanOrEqualOperator = @"_lte";
NSString *const SCPredicateEqualOperator = @"_eq";
NSString *const SCPredicateNotEqualOperator = @"_neq";
NSString *const SCPredicateExistsOperator = @"_exists";
NSString *const SCPredicateInOperator = @"_in";
NSString *const SCPredicateStringStartsWithOperator = @"_startswith";
NSString *const SCPredicateStringiStartsWithOperator = @"_istartswith";
NSString *const SCPredicateStringEndsWithOperator = @"_endswith";
NSString *const SCPredicateStringiEndsWithOperator = @"_iendswith";
NSString *const SCPredicateStringContainsOperator = @"_contains";
NSString *const SCPredicateStringiContainsOperator = @"_icontains";
NSString *const SCPredicateStringiEqualOperator = @"_ieq";
NSString *const SCPredicateIsOperator = @"_is";

static NSDateFormatter *dateFormatter;


@implementation SCPredicate

- (instancetype)initWithLeftHand:(NSString *)leftHand operator:(NSString *)operator rightHand:(id)rightHand {
    self = [super init];
    if (self) {
        self.leftHand = leftHand;
        self.operator = operator;
        self.rightHand = rightHand;
    }
    return self;
}

- (id)rightHand {
    if([_rightHand conformsToProtocol:@protocol(SCPredicateProtocol)]) {
        id<SCPredicateProtocol> rightHandPredicate = _rightHand;
        return [rightHandPredicate rawPredicate];
    }
    return _rightHand;
}

- (NSDictionary<NSString*,NSDictionary*> *)rawPredicate {
    return @{self.leftHand : @{self.operator : self.rightHand}};
}

- (NSString *)queryRepresentation {
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self rawPredicate]
                                                       options:0
                                                         error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)formattedStringFromDate:(NSDate *)date {
    return [[SCConstants SCDataObjectDatesTransformer] reverseTransformedValue:date];
}

+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanDate:(NSDate *)date {
    NSString *dateString = [self formattedStringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOrEqualOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOrEqualOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isGreaterThanOrEqualToDate:(NSDate *)date {
    NSString *dateString = [self formattedStringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateGreaterThanOrEqualOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key isLessThanString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanDate:(NSDate *)date {
    NSString *dateString = [self formattedStringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOperator rightHand:dateString];
}

+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOrEqualOperator rightHand:string];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToNumber:(NSNumber *)number {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateLessThanOrEqualOperator rightHand:number];
}
+ (SCPredicate *)whereKey:(NSString *)key isLessThanOrEqualToDate:(NSDate *)date {
    NSString *dateString = [self formattedStringFromDate:date];
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
    NSString *dateString = [self formattedStringFromDate:date];
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
    NSString *dateString = [self formattedStringFromDate:date];
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateNotEqualOperator rightHand:dateString];
}

+ (SCPredicate *)whereKeyExists:(NSString *)key {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateExistsOperator rightHand:@(YES)];
}

+ (SCPredicate *)whereKeyDoesNotExist:(NSString *)key {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateExistsOperator rightHand:@(NO)];
}

+ (SCPredicate *)whereKey:(NSString *)key inArray:(NSArray *)array {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateInOperator rightHand:array];
}

+ (SCPredicate *)whereKey:(NSString *)key satisfiesPredicate:(id<SCPredicateProtocol>)predicate {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateIsOperator rightHand:predicate];
}

#pragma mark - String predicates

+ (SCPredicate *)whereKey:(NSString *)key hasPrefix:(NSString *)prefix {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateStringStartsWithOperator rightHand:prefix];
}

+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveHasPrefix:(NSString *)prefix {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateStringiStartsWithOperator rightHand:prefix];
}

+ (SCPredicate *)whereKey:(NSString *)key hasSuffix:(NSString *)suffix {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateStringEndsWithOperator rightHand:suffix];
}

+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveHasSuffix:(NSString *)suffix {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateStringiEndsWithOperator rightHand:suffix];
}

+ (SCPredicate *)whereKey:(NSString *)key containsString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateStringContainsOperator rightHand:string];
}

+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveContainsString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateStringiContainsOperator rightHand:string];
}

+ (SCPredicate *)whereKey:(NSString *)key caseInsensitiveIsEqualToString:(NSString *)string {
    return [[SCPredicate alloc] initWithLeftHand:key operator:SCPredicateStringiEqualOperator rightHand:string];
}

@end
