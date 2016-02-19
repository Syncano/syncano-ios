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
    NSExpression *rexp = [NSExpression expressionForConstantValue:[self rightHandForNspredicate]];
    NSPredicateOperatorType op = [self nspredicateOperatorRepresentationForOperator:[self operator]];
    NSComparisonPredicateOptions options = [self nspredicateOptionsForOperator:[self operator]];
    
    NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:lexp
                                                         rightExpression:rexp
                                                                modifier:0
                                                                    type:op
                                                                 options:options];
    return predicate;
}

- (NSString*)rightHandForNspredicate {
    NSString* operator = [self operator];
    NSString* rightHand = [self rightHand];
    
    if ([operator isEqualToString:SCPredicateIsOperator]) {
        NSAssert(![operator isEqualToString:SCPredicateIsOperator], NSLocalizedString(@"SCPredicateIsOperator is not supported in local queries.", @""));
    }
    
    if([operator isEqualToString:SCPredicateStringContainsOperator] || [operator isEqualToString:SCPredicateStringiContainsOperator]) {
        rightHand = [NSString stringWithFormat:@"*%@*",rightHand];
    }
        
    return rightHand;
}

- (NSPredicateOperatorType)nspredicateOperatorRepresentationForOperator:(NSString *)operator {
    NSDictionary *operators = @{SCPredicateGreaterThanOperator : @(NSGreaterThanPredicateOperatorType),
                                SCPredicateGreaterThanOrEqualOperator : @(NSGreaterThanOrEqualToPredicateOperatorType),
                                SCPredicateLessThanOperator : @(NSLessThanPredicateOperatorType),
                                SCPredicateLessThanOrEqualOperator : @(NSLessThanOrEqualToPredicateOperatorType),
                                SCPredicateEqualOperator : @(NSEqualToPredicateOperatorType),
                                SCPredicateNotEqualOperator : @(NSNotEqualToPredicateOperatorType),
                                SCPredicateExistsOperator : @(NSEqualToPredicateOperatorType),
                                SCPredicateInOperator : @(NSInPredicateOperatorType),
                                SCPredicateStringStartsWithOperator: @(NSBeginsWithPredicateOperatorType),
                                SCPredicateStringiStartsWithOperator: @(NSBeginsWithPredicateOperatorType),
                                SCPredicateStringEndsWithOperator: @(NSEndsWithPredicateOperatorType),
                                SCPredicateStringiEndsWithOperator: @(NSEndsWithPredicateOperatorType),
                                SCPredicateStringiEqualOperator : @(NSEqualToPredicateOperatorType),
                                SCPredicateStringContainsOperator : @(NSLikePredicateOperatorType),
                                SCPredicateStringiContainsOperator : @(NSLikePredicateOperatorType)};
    
    return (NSPredicateOperatorType)[operators[operator] unsignedIntegerValue];
}

- (NSComparisonPredicateOptions)nspredicateOptionsForOperator:(NSString *)operator {
    NSDictionary *operators = @{SCPredicateStringiStartsWithOperator: @(NSCaseInsensitivePredicateOption),
                                SCPredicateStringiEndsWithOperator: @(NSCaseInsensitivePredicateOption),
                                SCPredicateStringiEqualOperator : @(NSCaseInsensitivePredicateOption),
                                SCPredicateStringiContainsOperator : @(NSCaseInsensitivePredicateOption)};
    
    NSNumber* option = operators[operator];
    if(option == nil) {
        return 0;
    }
    return [option unsignedIntegerValue];
}

@end
