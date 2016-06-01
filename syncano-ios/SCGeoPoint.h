//
//  SCGeoPoint.h
//  syncano-ios
//
//  Created by Jan Lipmann on 27/05/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "SCConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCGeoPoint : MTLModel<MTLJSONSerializing>
/**
 Latitude of point in degrees. Valid range is from `-90.0` to `90.0`.
 */
@property (nonatomic, assign) double latitude;

/**
 Longitude of point in degrees. Valid range is from `-180.0` to `180.0`.
 */
@property (nonatomic, assign) double longitude;

+ (instancetype)geoPointWithLocation:(CLLocation *)location;

+ (instancetype)geoPointWithLatitude:(double)latitude longitude:(double)longitude;

- (instancetype)initWithLocation:(CLLocation *)location;

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError * _Nullable __autoreleasing *)error;

@end
NS_ASSUME_NONNULL_END