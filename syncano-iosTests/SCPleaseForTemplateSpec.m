//
//  SCPleaseForTemplateSpec.m
//  syncano-ios
//
//  Created by Jakub Machoń on 25.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "SCPredicate.h"
#import "Book.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHPathHelpers.h"
#import "SCPleaseForTemplate.h"

SPEC_BEGIN(SCPleaseForTemplateSpec)

describe(@"SCPleaseForTemplate", ^{
    
    it(@"should init with a Data Object class", ^{
        SCPleaseForTemplate *please = [[SCPleaseForTemplate alloc] initWithDataObjectClass:[Book class]];
        [[please should] beNonNil];
    });
    
    it(@"should create new SCPleaseForTemplate object for provided class", ^{
        SCPlease *please = [SCPleaseForTemplate pleaseInstanceForDataObjectWithClass:[Book class] forTemplate:@"TEMPLATE_NAME"];
        [[please should] beNonNil];
        [[please should] beKindOfClass:[SCPleaseForTemplate class]];
    });
    
    it(@"should create new SCPleaseForTemplate object for provided class for provided Syncano instance", ^{
        Syncano *syncano = [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        SCPlease *please = [SCPleaseForTemplate pleaseInstanceForDataObjectWithClass:[Book class] forTemplate:@"TEMPLATE_NAME" forSyncano:syncano];
        [[please should] beNonNil];
        [[please.syncano should] equal:syncano];
        [[please should] beKindOfClass:[SCPleaseForTemplate class]];
        
    });
    
});

SPEC_END

