//
//  SCCompoundPredicateSpec.m
//  syncano-ios
//
//  Created by Jakub Machoń on 27.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"

SPEC_BEGIN(SCCompoundPredicateSpec)
describe(@"SCCompoundPredicate", ^{
    
    SCCompoundPredicate* compoundPredicate = [[SCCompoundPredicate alloc] init];
    context(@"when created", ^{
        it(@"is empty", ^{
            [[[compoundPredicate queryRepresentation] should] equal:@"{}"];
        });
    });
    context(@"when feeds with nil", ^{
        it(@"ignores it", ^{
            [compoundPredicate addPredicate:nil];
            [[[compoundPredicate queryRepresentation] should] equal:@"{}"];
        });
    });
    context(@"when data provided", ^{
        it(@"works for one", ^{
            [compoundPredicate addPredicate:[SCPredicate whereKey:@"test1" isEqualToNumber:@0]];
            [[[compoundPredicate queryRepresentation] should] equal:@"{\"test1\":{\"_eq\":0}}"];
        });
        it(@"works for more", ^{
            [compoundPredicate addPredicate:[SCPredicate whereKey:@"test4" isEqualToNumber:@21]];
            [[[compoundPredicate queryRepresentation] should] equal:@"{\"test1\":{\"_eq\":0},\"test4\":{\"_eq\":21}}"];
        });
    });
    
    it(@"works for queries on the same property", ^{
        SCCompoundPredicate *compoundPredicate = [SCCompoundPredicate compoundPredicateWithPredicates:@[
                                                               [SCPredicate whereKey:@"count" isGreaterThanNumber:@200],
                                                               [SCPredicate whereKey:@"count" isLessThanNumber:@280],
                                                               ]];
        
        NSString* expectedQuery = @"{\"count\":{\"_gt\":200,\"_lt\":280}}";
        [[[compoundPredicate queryRepresentation] should] equal:expectedQuery];
        
    });
    
    it(@"works for join queries", ^{
        SCCompoundPredicate* compoundPredicate = [[SCCompoundPredicate alloc] init];
        [compoundPredicate addPredicate:[SCPredicate whereKey:@"pages" satisfiesPredicate:
                                         [SCCompoundPredicate compoundPredicateWithPredicates:@[
                                                                                                [SCPredicate whereKey:@"count" isGreaterThanNumber:@200],
                                                                                                [SCPredicate whereKey:@"count" isLessThanNumber:@280],
                                                                                                ]]]];
        
        [compoundPredicate addPredicate:[SCPredicate whereKey:@"author" satisfiesPredicate:[SCPredicate whereKey:@"name" hasPrefix:@"S"]]];
        
        NSString* expectedQuery = @"{\"pages\":{\"_is\":{\"count\":{\"_gt\":200,\"_lt\":280}}},\"author\":{\"_is\":{\"name\":{\"_startswith\":\"S\"}}}}";
        
        [[[compoundPredicate queryRepresentation] should] equal:expectedQuery];
    });
    
    it(@"works for quering on many fields for referenced data", ^{
        SCCompoundPredicate* compoundPredicate = [[SCCompoundPredicate alloc] init];
        [compoundPredicate addPredicate:[SCPredicate whereKey:@"pages" satisfiesPredicate:
                                         [SCCompoundPredicate compoundPredicateWithPredicates:@[
                                                                                                [SCPredicate whereKey:@"count" isGreaterThanNumber:@200],
                                                                                                [SCPredicate whereKey:@"count" isLessThanNumber:@280],
                                                                                                [SCPredicate whereKey:@"paper_density" isEqualToNumber:@1]]
                                                                                                ]]];
        
        NSString* expectedQuery = @"{\"pages\":{\"_is\":{\"count\":{\"_gt\":200,\"_lt\":280},\"paper_density\":{\"_eq\":1}}}}";
        
        [[[compoundPredicate queryRepresentation] should] equal:expectedQuery];
    });

    it(@"works for really nested queries", ^{
        SCCompoundPredicate* compoundPredicate = [[SCCompoundPredicate alloc] init];
        [compoundPredicate addPredicate:[SCPredicate whereKey:@"pages" satisfiesPredicate:
                                         [SCCompoundPredicate compoundPredicateWithPredicates:@[
                                                                                                [SCPredicate whereKey:@"count" isGreaterThanNumber:@200],
                                                                                                [SCPredicate whereKey:@"image" satisfiesPredicate:[SCPredicate whereKey:@"content" inArray:@[@"Rakfisk",@"Torsk",@"Lutefisk"]]
                                                                                                ]
                                          ]]]];
        
        NSString* expectedQuery = @"{\"pages\":{\"_is\":{\"count\":{\"_gt\":200},\"image\":{\"_is\":{\"content\":{\"_in\":[\"Rakfisk\",\"Torsk\",\"Lutefisk\"]}}}}}}";
        NSLog(@"%@",expectedQuery);
        NSLog(@"%@",[compoundPredicate queryRepresentation]);
        
        [[[compoundPredicate queryRepresentation] should] equal:expectedQuery];
    });
    
});


SPEC_END
