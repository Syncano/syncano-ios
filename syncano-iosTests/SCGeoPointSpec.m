//
//  SCDataObjectSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import <UIKit/UIKit.h>
#import "Syncano.h"

SPEC_BEGIN(SCGeoPointSpec)

describe(@"SCGeoPoint", ^{
    
    double latitude = 52.2297;
    double longitude = 21.0122;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    it(@"should initialize with latitude and longitude", ^{
        SCGeoPoint *geopoint = [[SCGeoPoint alloc] initWithLatitude:latitude longitude:longitude];
        [[geopoint shouldNot] beNil];
        [[theValue(geopoint.latitude) should] equal:theValue(latitude)];
        [[theValue(geopoint.longitude) should] equal:theValue(longitude)];
    });
    
    it(@"should initialize with CLLocation", ^{
        SCGeoPoint *geopoint = [[SCGeoPoint alloc] initWithLocation:location];
        [[geopoint shouldNot] beNil];
        [[theValue(geopoint.latitude) should] equal:theValue(latitude)];
        [[theValue(geopoint.longitude) should] equal:theValue(longitude)];
    });

});

SPEC_END
