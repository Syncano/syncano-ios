//
//  SCPleaseForDataEndpoint.m
//  syncano-ios
//
//  Created by Jan Lipmann on 27.06.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPleaseForDataEndpoint.h"
#import "SCAPIClient+SCDataObject.h"
#import "SCPleaseProtected.h"
#import "NSDictionary+CacheKey.h"
#import "SCAPIClient_SCAPIClient.h"


@interface SCPleaseForDataEndpoint ()

/**
 *  API class name representation of connected SCDataObject Class
 */
@property (nonatomic,retain) NSString *dataEndpointName;

@end

@implementation SCPleaseForDataEndpoint

- (instancetype)initWithDataObjectClass:(Class)dataObjectClass fordataEndpoint:(nonnull NSString *)dataEndpointName {
    self = [super init];
    if (self) {
        self.dataEndpointName = dataEndpointName;
    }
    return self;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass fordataEndpoint:(nonnull NSString *)dataEndpointName {
    SCPleaseForDataEndpoint* instance = (SCPleaseForDataEndpoint*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass];
    instance.dataEndpointName = dataEndpointName;
    return instance;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass fordataEndpoint:(nonnull NSString *)dataEndpointName forSyncano:(nonnull Syncano *)syncano {
    SCPleaseForDataEndpoint* instance = (SCPleaseForDataEndpoint*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass forSyncano:syncano];
    instance.dataEndpointName = dataEndpointName;
    return instance;
}

- (void)getDataObjectFromAPIWithParams:(NSDictionary*)queryParameters completion:(SCDataObjectsCompletionBlock)completion {
    SCAPIClient *apiClient = [self.apiClient copy];
    apiClient.apiVersion = SCAPIVersion_1_1;
    [apiClient getDataObjectsFromdataEndpointWithName:self.dataEndpointName params:queryParameters completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        [self handleResponse:responseObject error:error completion:completion];
    }];
}


@end

@implementation SCPleaseForDataEndpoint (Cache)
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
