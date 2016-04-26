//
//  SCParseManager+SCLocalStorage.h
//  syncano-ios
//
//  Created by Jan Lipmann on 05/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCParseManager.h"

@class SCDataObject;

NS_ASSUME_NONNULL_BEGIN

@interface SCParseManager (SCLocalStorage)
/**
 *  Converts to JSON reresentation of SCObject for saving in local storage purposes
 *
 *  @param dataObject SCDataObject to convert
 *  @param error autoreleased error instance or nil
 *
 *  @return NSDictionary as a JSON represenation of provided SCObject
 */
- (nullable NSDictionary *)JSONRepresentationOfDataObject:(SCDataObject *)dataObject error:(NSError **)error;

/**
 *  Attempts to parse JSON representation to SCDataObject of provided class name
 *
 *  @param className      name of a class for this object
 *  @param JSONDictionary NSDictionary with JSON representation of a SCDataObject
 *  @param error          autoreleased error instance or nil
 *
 *  @return parsed SCDataObject or nil
 */
- (nullable SCDataObject *)parsedObjectOfClassWithName:(NSString *)className fromJSON:(NSDictionary *)JSONDictionary error:( NSError **)error;
@end
NS_ASSUME_NONNULL_END