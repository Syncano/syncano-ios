//
//  SCRequestCacheManager.m
//  syncano-ios
//
//  Created by Jan Lipmann on 07/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRequestCacheManager.h"
#import "SCRequest.h"

@interface SCRequestCacheManager ()
@property (nonatomic,retain) NSMutableDictionary *requestsStore;
@end

@implementation SCRequestCacheManager
- (void)enqueueRequest:(SCRequest *)request {
    if (!self.requestsStore) {
        self.requestsStore = [NSMutableDictionary new];
    }
    [self.requestsStore setObject:[request dictionaryRepresentation] forKey:request.identifier];
}

- (void)removeRequestWithIdentifier:(NSString *)identifier {
    if ([self.requestsStore objectForKey:identifier]) {
        [self.requestsStore removeObjectForKey:identifier];
    }
}


@end
