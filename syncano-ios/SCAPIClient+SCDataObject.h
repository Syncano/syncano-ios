//
//  SCAPIClient+SCDataObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCAPIClient (SCDataObject)

/**
 *  Attempts to fetch SCDataObjects for class name with parameters
 *
 *  @param className  class name of objects to fetch
 *  @param params     fetch parameters
 *  @param completion completion block
 */
- (void)getDataObjectsFromClassName:(NSString *)className params:(nullable NSDictionary *)params completion:(SCAPICompletionBlock)completion;

/**
 *  Attempts do fetch object of provided class name with provided id
 *
 *  @param className  class name of object to fetch
 *  @param identifier object id
 *  @param completion completion block
 */
- (void)getDataObjectsFromClassName:(NSString *)className withId:(NSNumber *)identifier completion:(SCAPICompletionBlock)completion;

/**
 *  Attempts to fetch data object from view
 *
 *  @param viewName   name of a view
 *  @param params     parameters
 *  @param completion completion block
 */
- (void)getDataObjectsFromViewName:(NSString *)viewName params:(nullable NSDictionary *)params completion:(SCAPICompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END