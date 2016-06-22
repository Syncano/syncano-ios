//
//  NSDictionary+Cache.m
//  syncano-ios
//
//  Created by Jan Lipmann on 22/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "NSDictionary+CacheKey.h"
#import "SCConstants.h"

@implementation NSDictionary (CacheKey)
- (NSDictionary *)dictionaryByAddingCacheKey:(NSString *)cacheKey {
    if (self) {
        NSMutableDictionary *mutable = [self mutableCopy];
        mutable[SCPleaseParameterCacheKey] = cacheKey;
        return [NSDictionary dictionaryWithDictionary:mutable];
    } else {
        return @{SCPleaseParameterCacheKey : cacheKey};
    }
}
@end
