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

SINGLETON_IMPL_FOR_CLASS(SCRequestCacheManager);


- (NSMutableDictionary *)requestsStore {
    if (!_requestsStore) {
        _requestsStore = [NSMutableDictionary new];
    }
    return _requestsStore;
}

- (void)enqueueGETRequestWithPath:(NSString *)path params:(NSDictionary *)params {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodGET params:params];
    [self enqueueRequest:request];
}
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPOST params:params];
    [self enqueueRequest:request];
}
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPATCH params:params];
    [self enqueueRequest:request];
}
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodDELETE params:params];
    [self enqueueRequest:request];
}
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPUT params:params];
    [self enqueueRequest:request];
}


- (void)enqueueRequest:(SCRequest *)request {
    [self.requestsStore setObject:[request dictionaryRepresentation] forKey:request.identifier];
}

- (void)removeRequestWithIdentifier:(NSString *)identifier {
    if ([self.requestsStore objectForKey:identifier]) {
        [self.requestsStore removeObjectForKey:identifier];
    }
}


@end
