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
    return [NSPredicate predicateWithFormat:@"%@ %@ %@",self.leftHand , [self nspredicateOperatorRepresentationForOperator:self.operator],self.rightHand];
}

- (NSString *)nspredicateOperatorRepresentationForOperator:(NSString *)operator {
    NSDictionary *operators = @{SCPredicateGreaterThanOperator : @">",
                                SCPredicateGreaterThanOrEqualOperator : @">=",
                                SCPredicateLessThanOperator : @"<",
                                SCPredicateLessThanOrEqualOperator : @"<=",
                                SCPredicateEqualOperator : @"==",
                                SCPredicateNotEqualOperator : @"!=",
                                SCPredicateExistsOperator : @"==",
                                SCPredicateInOperator : @"IN"};
    
    return operators[operator];
}
@end
