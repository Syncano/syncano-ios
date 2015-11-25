//
//  SCPredicate+LocalStorage.m
//  syncano-ios
//
//  Created by Jan Lipmann on 24/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCPredicate+LocalStorage.h"

@implementation SCPredicate (LocalStorage)
- (NSPredicate *)nspredicateRepresentation {
    NSExpression *lexp = [NSExpression expressionForKeyPath:[self leftHand]];
    NSExpression *rexp = [NSExpression expressionForConstantValue:[self rightHand]];
    NSPredicateOperatorType op = [self nspredicateOperatorRepresentationForOperator:[self operator]];
    
    NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lexp
                                                         rightExpression:rexp
                                                                modifier:0
                                                                    type:op
                                                                 options:0];
    return predicate;
}

- (NSPredicateOperatorType)nspredicateOperatorRepresentationForOperator:(NSString *)operator {
    NSDictionary *operators = @{SCPredicateGreaterThanOperator : @(NSGreaterThanPredicateOperatorType),
                                SCPredicateGreaterThanOrEqualOperator : @(NSGreaterThanOrEqualToPredicateOperatorType),
                                SCPredicateLessThanOperator : @(NSLessThanPredicateOperatorType),
                                SCPredicateLessThanOrEqualOperator : @(NSLessThanOrEqualToPredicateOperatorType),
                                SCPredicateEqualOperator : @(NSEqualToPredicateOperatorType),
                                SCPredicateNotEqualOperator : @(NSNotEqualToPredicateOperatorType),
                                SCPredicateExistsOperator : @(NSEqualToPredicateOperatorType),
                                SCPredicateInOperator : @(NSInPredicateOperatorType)};
    
    return (NSPredicateOperatorType)[operators[operator] unsignedIntegerValue];
}
@end
