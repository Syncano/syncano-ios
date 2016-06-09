//
//  SCDataObject+Properties.h
//  syncano-ios
//
//  Created by Jan Lipmann on 11/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCDataObject.h"
NS_ASSUME_NONNULL_BEGIN
@interface SCDataObject (Properties)

/**
 *  Returns all property names of SCFile class
 *
 *  @return NSArray of strings
 */
+ (NSArray *)propertiesNamesOfFileClass;

/**
 *  Returns all property names of SCRelation class
 *
 *  @return NSArray of strings
 */
+ (NSArray *)propertiesNamesOfSCRelationClass;

/**
 *  Returns classes of all properties inside a SCDataObject
 *
 *  @return NSDictionary with property name as a key and property class name as a value
 */
+ (NSDictionary *)classesOfProperties;
@end
NS_ASSUME_NONNULL_END