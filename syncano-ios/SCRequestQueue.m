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
#import "SCFileManager.h"

@interface SCRequestQueue ()
@property (nonatomic,retain) NSMutableArray *requestsStore;
@end

@implementation SCRequestQueue

- (instancetype)initWithIdentifier:(NSString *)identifier delegate:(id<SCRequestQueueDelegate>)delegate {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.delegate = delegate;
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
    [self enqueueGETRequestWithPath:path params:params callback:callback save:NO];
}
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    [self enqueuePOSTRequestWithPath:path params:params callback:callback save:NO];
}
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    [self enqueuePATCHRequestWithPath:path params:params callback:callback save:NO];
}
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    [self enqueueDELETERequestWithPath:path params:params callback:callback save:NO];
}
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback {
    [self enqueuePUTRequestWithPath:path params:params callback:callback save:NO];
}
- (void)enqueueUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback {
    [self enqueueUploadRequestWithPath:path propertyName:propertyName fileData:fileData callback:callback save:NO];
}

- (void)enqueueGETRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodGET params:params callback:callback save:save];
    [self enqueueRequest:request];
}
- (void)enqueuePOSTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPOST params:params callback:callback save:save];
    [self enqueueRequest:request];
}
- (void)enqueuePATCHRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPATCH params:params callback:callback save:save];
    [self enqueueRequest:request];
}
- (void)enqueueDELETERequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodDELETE params:params callback:callback save:save];
    [self enqueueRequest:request];
}
- (void)enqueuePUTRequestWithPath:(NSString *)path params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCRequest *request = [SCRequest requestWithPath:path method:SCRequestMethodPUT params:params callback:callback save:save];
    [self enqueueRequest:request];
}

- (void)enqueueUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCUploadRequest *request = [SCUploadRequest uploadRequestWithPath:path propertName:propertyName fileData:fileData callback:callback save:save];
    [self enqueueRequest:request];
}

- (void)enqueueRequest:(SCRequest *)request{
    if (request.save) {
        [SCFileManager writeAsyncRequest:request queueIdentifier:self.identifier completionBlock:^(NSError *error) {
            [self.requestsStore addObject:request];
            if ([self.delegate respondsToSelector:@selector(requestQueue:didSavedRequest:)]) {
                [self.delegate requestQueue:self didSavedRequest:request];
            }
        }];
    } else {
        [self.requestsStore addObject:request];
    }
    
    
}

- (void)removeRequest:(SCRequest *)request {
    if ([self.requestsStore containsObject:request]) {
        [self.requestsStore removeObject:request];
    }
    if (request.save) {
        [SCFileManager removeAsyncRequest:request queueIdentifier:self.identifier completionBlock:^(NSError *error) {
            if (error) {
                //TODO: handle this error
            }
        }];
    }
}


@end
