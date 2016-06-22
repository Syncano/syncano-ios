//
//  NSDictionary+Cache.h
//  syncano-ios
//
//  Created by Jan Lipmann on 22/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CacheKey)
- (NSDictionary *)dictionaryByAddingCacheKey:(NSString *)cacheKey;
@end
