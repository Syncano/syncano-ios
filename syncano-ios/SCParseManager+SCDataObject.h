//
//  SCParseManager+SCDataObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 07/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCParseManager.h"
#import "SCDataObject.h"

@interface SCParseManager (SCDataObject)

/**
 *  Attempts to parse JSON to SCDataObject
 *
 *  @param objectClass Class of object to parse for
 *  @param JSONObject  serialized JSON object from API response
 *
 *  @return parsed SCDataObject
 */
- (id)parsedObjectOfClass:(__unsafe_unretained Class)objectClass
           fromJSONObject:(id)JSONObject;

/**
 *  Attempts to parse JSON response object to array of SCDataObjects
 *
 *  @param objectClass    objectClass Class of object to parse for
 *  @param responseObject JSON object with array of serialized JSON objects from API response
 *  @return NSArray with parsed SCDataObjects
 */
- (NSArray *)parsedObjectsOfClass:(__unsafe_unretained Class)objectClass
                   fromJSONObject:(id)responseObject;


/**
 *  Attempt to fill provided SCDataObject with data from JSON response object. 
 *
 *  @param object         SCDataObject to update
 *  @param responseObject JSON response object to update from
 */
- (void)fillObject:(SCDataObject *)object withDataFromJSONObject:(id)responseObject;

/**
 *  Converts SCDataObject to NSDictionary representation
 *
 *  @param dataObject SCDataObject to convert
 *
 *  @return JSON representation of SCDataObject
 */
- (NSDictionary *)JSONSerializedDictionaryFromDataObject:(SCDataObject *)dataObject error:(NSError **)error;


@end
