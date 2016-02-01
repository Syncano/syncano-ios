//
//  SCPredicateSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 24/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"

SPEC_BEGIN(SCPredicateSpec)
describe(@"SCpredicate", ^{
    
    __block SCPredicate *predicate;
    __block NSString *expectedQuery;
    __block NSString *queryRepresentation;
    __block NSDate *date;
    __block NSDateFormatter *dateFormatter;
    
    beforeAll(^{
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        date = [NSDate date];
    });
    
    //Greater
    it(@"should generate query greater than string statement", ^{
        predicate = [SCPredicate whereKey:@"left" isGreaterThanString:@"right"];
        expectedQuery = @"{\"left\":{\"_gt\":\"right\"}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    it(@"should generate query greater than number statement", ^{
        predicate = [SCPredicate whereKey:@"left" isGreaterThanNumber:@(1)];
        expectedQuery = @"{\"left\":{\"_gt\":1}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    it(@"should generate query greater than date statement", ^{
        predicate = [SCPredicate whereKey:@"left" isGreaterThanDate:date];
        expectedQuery = [NSString stringWithFormat:@"{\"left\":{\"_gt\":\"%@\"}}",[dateFormatter stringFromDate:date]];
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    //Less
    it(@"should generate query less than string statement", ^{
        predicate = [SCPredicate whereKey:@"left" isLessThanString:@"right"];
        expectedQuery = @"{\"left\":{\"_lt\":\"right\"}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    it(@"should generate query less than number statement", ^{
        predicate = [SCPredicate whereKey:@"left" isLessThanNumber:@(1)];
        expectedQuery = @"{\"left\":{\"_lt\":1}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    it(@"should generate query less than date statement", ^{
        predicate = [SCPredicate whereKey:@"left" isLessThanDate:date];
        expectedQuery = [NSString stringWithFormat:@"{\"left\":{\"_lt\":\"%@\"}}",[dateFormatter stringFromDate:date]];
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });


    //Less or equal
    it(@"should generate query less or equal than string statement", ^{
        predicate = [SCPredicate whereKey:@"left" isLessThanOrEqualToString:@"right"];
        expectedQuery = @"{\"left\":{\"_lte\":\"right\"}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    it(@"should generate query less or equal than number statement", ^{
        predicate = [SCPredicate whereKey:@"left" isLessThanOrEqualToNumber:@(1)];
        expectedQuery = @"{\"left\":{\"_lte\":1}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    it(@"should generate query less or equal than date statement", ^{
        predicate = [SCPredicate whereKey:@"left" isLessThanOrEqualToDate:date];
        expectedQuery = [NSString stringWithFormat:@"{\"left\":{\"_lte\":\"%@\"}}",[dateFormatter stringFromDate:date]];
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    
    //Equal
    it(@"should generate query equal to string statement", ^{
        predicate = [SCPredicate whereKey:@"left" isEqualToString:@"right"];
        expectedQuery = @"{\"left\":{\"_eq\":\"right\"}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    it(@"should generate query equal to number statement", ^{
        predicate = [SCPredicate whereKey:@"left" isEqualToNumber:@(1)];
        expectedQuery = @"{\"left\":{\"_eq\":1}}";;
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    it(@"should generate query equal to bool statement", ^{
        predicate = [SCPredicate whereKey:@"left" isEqualToBool:YES];
        expectedQuery = @"{\"left\":{\"_eq\":true}}";;
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    it(@"should generate query equal to date statement", ^{
        predicate = [SCPredicate whereKey:@"left" isEqualToDate:date];
        expectedQuery = [NSString stringWithFormat:@"{\"left\":{\"_eq\":\"%@\"}}",[dateFormatter stringFromDate:date]];
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    //Not Equal
    it(@"should generate query not equal to string statement", ^{
        predicate = [SCPredicate whereKey:@"left" notEqualToString:@"right"];
        expectedQuery = @"{\"left\":{\"_neq\":\"right\"}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    it(@"should generate query equal to number statement", ^{
        predicate = [SCPredicate whereKey:@"left" notEqualToNumber:@(1)];
        expectedQuery = @"{\"left\":{\"_neq\":1}}";;
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    it(@"should generate query equal to bool statement", ^{
        predicate = [SCPredicate whereKey:@"left" notEqualToBool:YES];
        expectedQuery = @"{\"left\":{\"_neq\":true}}";;
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    it(@"should generate query equal to date statement", ^{
        predicate = [SCPredicate whereKey:@"left" notEqualToDate:date];
        expectedQuery = [NSString stringWithFormat:@"{\"left\":{\"_neq\":\"%@\"}}",[dateFormatter stringFromDate:date]];
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    //Exist
    it(@"should generate query key exist statement", ^{
        predicate = [SCPredicate whereKeyExists:@"left"];
        expectedQuery = @"{\"left\":{\"_exists\":true}}";;
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    //In
    it(@"should generate query key exist statement", ^{
        predicate = [SCPredicate whereKey:@"left" inArray:@[@"hand",@"foot"]];
        expectedQuery = @"{\"left\":{\"_in\":[\"hand\",\"foot\"]}}";
        queryRepresentation = [predicate queryRepresentation];
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    //Is
    it(@"should generate join query", ^{
        predicate = [SCPredicate whereKey:@"author" satisfiesPredicate:
                     [SCPredicate whereKey:@"name" isEqualToString:@"Prus"]];
        expectedQuery = @"{\"author\":{\"_is\":{\"name\":{\"_eq\":\"Prus\"}}}}";
        queryRepresentation = [predicate queryRepresentation];
        
        NSLog(@"%@",expectedQuery);
        NSLog(@"%@",queryRepresentation);
        
        [[queryRepresentation should] equal:expectedQuery];
    });
    
    context(@"String functions", ^{
        //starts with
        it(@"should generate starts with query statement", ^{
            predicate = [SCPredicate whereKey:@"left" hasPrefix:@"beginning"];
            expectedQuery = @"{\"left\":{\"_startswith\":\"beginning\"}}";
            queryRepresentation = [predicate queryRepresentation];
            [[queryRepresentation should] equal:expectedQuery];
        });
        
        //starts with case insensitive
        it(@"should generate starts with case insensitive query statement", ^{
            predicate = [SCPredicate whereKey:@"left" caseInsensitiveHasPrefix:@"beginning"];
            expectedQuery = @"{\"left\":{\"_istartswith\":\"beginning\"}}";
            queryRepresentation = [predicate queryRepresentation];
            [[queryRepresentation should] equal:expectedQuery];
        });
        
        //ends with
        it(@"should generate ends with query statement", ^{
            predicate = [SCPredicate whereKey:@"left" hasSuffix:@"end"];
            expectedQuery = @"{\"left\":{\"_endswith\":\"end\"}}";
            queryRepresentation = [predicate queryRepresentation];
            [[queryRepresentation should] equal:expectedQuery];
        });
        
        //ends with case insensitive
        it(@"should generate ends with case insensitive query statement", ^{
            predicate = [SCPredicate whereKey:@"left" caseInsensitiveHasSuffix:@"end"];
            expectedQuery = @"{\"left\":{\"_iendswith\":\"end\"}}";
            queryRepresentation = [predicate queryRepresentation];
            [[queryRepresentation should] equal:expectedQuery];
        });
        
        //contains
        it(@"should generate contains query statement", ^{
            predicate = [SCPredicate whereKey:@"left" containsString:@"middle"];
            expectedQuery = @"{\"left\":{\"_contains\":\"middle\"}}";
            queryRepresentation = [predicate queryRepresentation];
            [[queryRepresentation should] equal:expectedQuery];
        });
        
        //contains case insensitive
        it(@"should generate contains case insensitive query statement", ^{
            predicate = [SCPredicate whereKey:@"left" caseInsensitiveContainsString:@"middle"];
            expectedQuery = @"{\"left\":{\"_icontains\":\"middle\"}}";
            queryRepresentation = [predicate queryRepresentation];
            [[queryRepresentation should] equal:expectedQuery];
        });
        
        //equals case insensitive
        it(@"should generate equals case insensitive query statement", ^{
            predicate = [SCPredicate whereKey:@"left" caseInsensitiveIsEqualToString:@"the SaMe"];
            expectedQuery = @"{\"left\":{\"_ieq\":\"the SaMe\"}}";
            queryRepresentation = [predicate queryRepresentation];
            [[queryRepresentation should] equal:expectedQuery];
        });
    });
});


SPEC_END
