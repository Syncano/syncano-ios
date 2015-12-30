//
//  SCRequestCacheManager.m
//  syncano-ios
//
//  Created by Jan Lipmann on 07/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRequestQueue.h"
#import "SCRequest.h"
#import "SCUploadRequest.h"

@interface SCRequestQueue ()
@property (nonatomic,retain) NSMutableArray *requestsStore;
@end

@implementation SCRequestQueue

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
    }
    return self;
}

- (BOOL)hasRequests {
    return self.requestsStore.count > 0;
}

- (SCRequest *)dequeueRequest {
    SCRequest *request = [self.requestsStore firstObject];
    [self removeRequest:request];
    return request;
}

- (NSMutableArray *)requestsStore {
    if (!_requestsStore) {
        _requestsStore = [NSMutableArray new];
    }
    return _requestsStore;
}

- (void)enqueueGETRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodGET params:params callback:callback];
    [self enqueueRequest:request];
}
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPOST params:params callback:callback];
    [self enqueueRequest:request];
}
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPATCH params:params callback:callback];
    [self enqueueRequest:request];
}
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodDELETE params:params callback:callback];
    [self enqueueRequest:request];
}
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPUT params:params callback:callback];
    [self enqueueRequest:request];
}

- (void)enqueueUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback {
    SCUploadRequest *request = [SCUploadRequest uploadrRequestWithPath:path propertName:propertyName fileData:fileData callback:callback];
    [self enqueueRequest:request];
}

- (void)enqueueRequest:(SCRequest *)request {
    [self.requestsStore addObject:request];
}

- (void)removeRequest:(SCRequest *)request {
    if ([self.requestsStore containsObject:request]) {
        [self.requestsStore removeObject:request];
    }
}


@end
