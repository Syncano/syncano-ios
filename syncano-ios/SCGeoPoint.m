//
//  SCGeoPoint.m
//  syncano-ios
//
//  Created by Jan Lipmann on 27/05/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCGeoPoint.h"
#import "NSObject+SCParseHelper.h"


@implementation SCGeoPoint

+ (instancetype)geoPointWithLocation:(CLLocation *)location {
    return [self geoPointWithLatitude:location.coordinate.latitude
                            longitude:location.coordinate.longitude];
}

+ (instancetype)geoPointWithLatitude:(double)latitude longitude:(double)longitude {
    SCGeoPoint *geopoint = [[self alloc] initWithLatitude:latitude longitude:longitude];
    return geopoint;
}

- (instancetype)initWithLocation:(CLLocation *)location {
    return [self initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
}

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude {
    self = [super init];
    if (self) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError * _Nullable __autoreleasing *)error {
    self = [super init];
    if (self) {
        self.latitude = [[dictionaryValue[@"latitude"] sc_numberOrNil] doubleValue];
        self.longitude = [[dictionaryValue[@"longitude"] sc_numberOrNil] doubleValue];
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}
@end
