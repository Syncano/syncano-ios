//
//  SCCoumpoundPredicate.m
//  syncano-ios
//
//  Created by Jan Lipmann on 19/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCCompoundPredicate.h"


@interface SCCompoundPredicate ()
@end

@implementation SCCompoundPredicate {
    NSMutableArray *_predicates;
}

- (NSArray *)predicates {
    return [NSArray arrayWithArray:_predicates];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _predicates = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithPredicates:(NSArray *)predicates {
    self = [self init];
    if (self) {
        _predicates = [predicates mutableCopy];
    }
    return self;
}

+ (instancetype)compoundPredicateWithPredicates:(NSArray *)predicates {
    return [[self alloc] initWithPredicates:predicates];
}

- (void)addPredicate:(id<SCPredicateProtocol>)predicate {
    if (!predicate || ![predicate conformsToProtocol:@protocol(SCPredicateProtocol)]) {
        return;
    }
    [_predicates addObject:predicate];
}

- (NSDictionary<NSString*,NSDictionary*> *)rawPredicate {
    NSMutableDictionary<NSString*,NSMutableDictionary*>* dictionary = [NSMutableDictionary dictionaryWithCapacity:self.predicates.count];
    for(id<SCPredicateProtocol> predicate in self.predicates) {
        NSDictionary<NSString*,NSDictionary*>* localPredicate = [predicate rawPredicate];
        for(NSString* key in localPredicate.allKeys) {
            NSMutableDictionary* localDictionary = dictionary[key];
            if(localDictionary == nil) {
                dictionary[key] = [NSMutableDictionary dictionaryWithDictionary:localPredicate[key]];
            } else {//AND on the same field f.e. {"year":{"_gte":1978,"_lte":1994}}
                [localDictionary addEntriesFromDictionary:localPredicate[key]];
            }
        }
    }
    
    return dictionary;
}

- (NSString *)queryRepresentation {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self rawPredicate]
                                                       options:0
                                                         error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
