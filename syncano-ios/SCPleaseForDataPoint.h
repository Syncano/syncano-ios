//
//  SCPleaseForDataPoint.h
//  syncano-ios
//
//  Created by Jan Lipmann on 27.06.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//
//

#import "SCPlease.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCPleaseForDataPoint: SCPlease

/**
 *  Initializes new empty SCPlease object for provided SCDataObject class
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param dataPoint Name of Data Point
 *
 *  @return SCPlease object
 */
- (instancetype)initWithDataObjectClass:(Class)dataObjectClass forDataPoint:(NSString*)dataPointName;

/**
 *  Creates a new SCPlease object for provided class for singleton Syncano instance.
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param dataPoint Name of Data Point
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forDataPoint:(NSString*)dataPointName;

/**
 *  Creates a new SCPlease object for provided class for provided Syncano instance
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param dataPoint Name of Data Point
 *  @param syncano         Syncano instance
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forDataPoint:(NSString*)dataPointName forSyncano:(Syncano *)syncano;

@end

@interface SCPleaseForDataPoint (Cache)
- (void)giveMeDataObjectsFromCacheWithKey:(NSString *)cacheKey withCompletion:(SCDataObjectsCompletionBlock)completion;
- (void)giveMeDataObjectsWithParameters:(NSDictionary *)parameters fromCacheWithKey:(NSString *)cacheKey completion:(SCDataObjectsCompletionBlock)completion;
- (void)giveMeDataObjectsWithPredicate:(id<SCPredicateProtocol>)predicate parameters:(NSDictionary *)parameters fromCacheWithKey:(NSString *)cacheKey completion:(SCDataObjectsCompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END