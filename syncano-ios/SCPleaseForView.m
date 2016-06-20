//
//  SCPleaseForView.m
//  syncano-ios
//
//  Created by Jakub Machoń on 25.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPleaseForView.h"
#import "SCAPIClient+SCDataObject.h"
#import "SCPleaseProtected.h"

@interface SCPleaseForView ()

/**
 *  API class name representation of connected SCDataObject Class
 */
@property (nonatomic,retain) NSString *viewName;

@property (nonatomic,retain) NSString *cacheKey;

@end

@implementation SCPleaseForView

- (instancetype)initWithDataObjectClass:(Class)dataObjectClass forView:(NSString*)viewName {
    self = [super init];
    if (self) {
        self.viewName = viewName;
    }
    return self;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forView:(NSString*)viewName {
    SCPleaseForView* instance = (SCPleaseForView*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass];
    instance.viewName = viewName;
    return instance;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forView:(NSString*)viewName forSyncano:(Syncano *)syncano {
    SCPleaseForView* instance = (SCPleaseForView*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass forSyncano:syncano];
    instance.viewName = viewName;
    return instance;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forView:(NSString *)viewName withCacheKey:(NSString *)cacheKey {
    SCPleaseForView* instance = (SCPleaseForView*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass];
    instance.viewName = viewName;
    instance.cacheKey = cacheKey;
    return instance;
}

+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forView:(NSString *)viewName forSyncano:(Syncano *)syncano withCacheKey:(NSString *)cacheKey {
    SCPleaseForView* instance = (SCPleaseForView*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass forSyncano:syncano];
    instance.viewName = viewName;
    instance.cacheKey = cacheKey;
    return instance;
}

- (void)getDataObjectFromAPIWithParams:(NSDictionary*)queryParameters completion:(SCDataObjectsCompletionBlock)completion {
    if (self.cacheKey.length > 0) {
        if (queryParameters) {
            NSMutableDictionary *mutableQueryParameters = [queryParameters mutableCopy];
            mutableQueryParameters[SCPleaseParameterCacheKey] = self.cacheKey;
            queryParameters = [NSDictionary dictionaryWithDictionary:mutableQueryParameters];
        } else {
            queryParameters = @{SCPleaseParameterCacheKey : self.cacheKey};
        }
    }
    [[self apiClient] getDataObjectsFromViewName:self.viewName params:queryParameters completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [self handleResponse:responseObject error:error completion:completion];
    }];
}


@end
