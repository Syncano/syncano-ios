//
//  SCPleaseForView.h
//  syncano4-ios
//
//  Created by Jakub Machoń on 25.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPlease.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCPleaseForView : SCPlease

/**
 *  Initializes new empty SCPlease object for provided SCDataObject class
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param viewName Name of Data Object View
 *
 *  @return SCPlease object
 */
- (instancetype)initWithDataObjectClass:(Class)dataObjectClass forView:(NSString*)viewName;

/**
 *  Creates a new SCPlease object for provided class for singleton Syncano instance.
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param viewName Name of Data Object View
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forView:(NSString*)viewName;

/**
 *  Creates a new SCPlease object for provided class for provided Syncano instance
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param viewName Name of Data Object View
 *  @param syncano         Syncano instance
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forView:(NSString*)viewName forSyncano:(Syncano *)syncano;

@end

@interface SCPleaseForView (Cache)
- (void)giveMeDataObjectsFromCacheWithKey:(NSString *)cacheKey withCompletion:(SCDataObjectsCompletionBlock)completion;
- (void)giveMeDataObjectsWithParameters:(NSDictionary *)parameters fromCacheWithKey:(NSString *)cacheKey completion:(SCDataObjectsCompletionBlock)completion;
- (void)giveMeDataObjectsWithPredicate:(id<SCPredicateProtocol>)predicate parameters:(NSDictionary *)parameters fromCacheWithKey:(NSString *)cacheKey completion:(SCDataObjectsCompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END