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
        [self findSavedRequests];
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
- (void)enqueuePOSTUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback {
    [self enqueuePOSTUploadRequestWithPath:path propertyName:propertyName fileData:fileData callback:callback save:NO];
}
- (void)enqueuePATCHUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback {
    [self enqueuePATCHUploadRequestWithPath:path propertyName:propertyName fileData:fileData callback:callback save:NO];
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
- (void)enqueuePOSTUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCUploadRequest *request = [SCUploadRequest uploadRequestWithPath:path method:SCRequestMethodPOST propertName:propertyName fileData:fileData callback:callback save:save];
    [self enqueueRequest:request];
}
- (void)enqueuePATCHUploadRequestWithPath:(NSString *)path propertyName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCUploadRequest *request = [SCUploadRequest uploadRequestWithPath:path method:SCRequestMethodPATCH propertName:propertyName fileData:fileData callback:callback save:save];
    [self enqueueRequest:request];
}

- (void)enqueueRequest:(SCRequest *)request onTop:(BOOL)onTop {
    if (request.save) {
        [SCFileManager writeAsyncRequest:request queueIdentifier:self.identifier completionBlock:^(NSError *error) {
            [self.requestsStore addObject:request];
            if ([self.delegate respondsToSelector:@selector(requestQueue:didSavedRequest:)]) {
                [self.delegate requestQueue:self didSavedRequest:request];
            }
        }];
    } else {
        if (onTop) {
            [self.requestsStore insertObject:request atIndex:0];
        } else {
            [self.requestsStore addObject:request];
        }
    }
}

- (void)enqueueRequest:(SCRequest *)request{
    [self enqueueRequest:request onTop:NO];
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

- (void)findSavedRequests {
    [SCFileManager findAllRequestArchivesForQueueWithIdentifier:self.identifier completionBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            NSError *_error;
            for (NSData *data in objects) {
                NSDictionary *dictionaryRepresentation = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:NSJSONReadingAllowFragments
                                                                               error:&_error];
                if (!error) {
                    SCRequest *request = [[SCRequest alloc] initFromDictionaryRepresentation:dictionaryRepresentation];
                    request.save = YES;
                    [self.requestsStore addObject:request];
                }
            }
            if ([self.delegate respondsToSelector:@selector(requestQueueDidEnqueuedRequestsFromDisk:)]) {
                [self.delegate requestQueueDidEnqueuedRequestsFromDisk:self];
            }
        }
    }];
}

@end
