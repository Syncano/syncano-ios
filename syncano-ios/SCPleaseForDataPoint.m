//
//  SCPleaseForDataPoint.m
//  syncano-ios
//
//  Created by Jan Lipmann on 27.06.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPleaseForDataPoint.h"
#import "SCAPIClient+SCDataObject.h"
#import "SCPleaseProtected.h"
#import "NSDictionary+CacheKey.h"

@interface SCPleaseForDataPoint ()

/**
 *  API class name representation of connected SCDataObject Class
 */
@property (nonatomic,retain) NSString *dataPointName;

@end

@implementation SCPleaseForDataPoint

- (instancetype)initWithDataObjectClass:(Class)dataObjectClass forDataPoint:(nonnull NSString *)dataPointName {
    self = [super init];
    if (self) {
        self.dataPointName = dataPointName;
    }
    return self;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forDataPoint:(nonnull NSString *)dataPointName {
    SCPleaseForDataPoint* instance = (SCPleaseForDataPoint*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass];
    instance.dataPointName = dataPointName;
    return instance;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forDataPoint:(nonnull NSString *)dataPointName forSyncano:(nonnull Syncano *)syncano {
    SCPleaseForDataPoint* instance = (SCPleaseForDataPoint*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass forSyncano:syncano];
    instance.dataPointName = dataPointName;
    return instance;
}

- (void)getDataObjectFromAPIWithParams:(NSDictionary*)queryParameters completion:(SCDataObjectsCompletionBlock)completion {
    [[self apiClient] getDataObjectsFromDataPointWithName:self.dataPointName params:queryParameters completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleResponse:responseObject error:error completion:completion];
    }];
}


@end

@implementation SCPleaseForDataPoint (Cache)
- (void)giveMeDataObjectsFromCacheWithKey:(NSString *)cacheKey withCompletion:(SCDataObjectsCompletionBlock)completion {
    [self giveMeDataObjectsWithParameters:[NSDictionary dictionaryWithCacheKey:cacheKey] completion:completion];
}
- (void)giveMeDataObjectsWithParameters:(NSDictionary *)parameters fromCacheWithKey:(NSString *)cacheKey completion:(SCDataObjectsCompletionBlock)completion {
    [self giveMeDataObjectsWithParameters:[parameters dictionaryByAddingCacheKey:cacheKey] completion:completion];
}
- (void)giveMeDataObjectsWithPredicate:(id<SCPredicateProtocol>)predicate parameters:(NSDictionary *)parameters fromCacheWithKey:(NSString *)cacheKey completion:(SCDataObjectsCompletionBlock)completion {
    [self giveMeDataObjectsWithPredicate:predicate parameters:[parameters dictionaryByAddingCacheKey:cacheKey] completion:completion];
}
@end
