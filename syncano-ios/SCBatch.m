//
//  SCBatch.m
//  syncano-ios
//
//  Created by Jan Lipmann on 01/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCBatch.h"
#import "SCBatchRequest.h"
#import "SCParseManager+SCDataObject.h"
#import "SCAPIClient.h"
#import "Syncano.h"
#import "NSError+SCBatch.h"
#import "SCBatchResponseItem.h"

static NSInteger maxRequestsCount = 50;

@interface SCBatch ()
@property (nonatomic,assign) SCAPIClient *apiClient;
@property (nonatomic,retain) NSMutableArray *requests;
@end

@implementation SCBatch

+ (SCBatch *)batch {
    SCBatch *batch = [SCBatch new];
    batch.apiClient = [Syncano sharedAPIClient];
    return batch;
}
+ (SCBatch *)batchForSyncano:(Syncano *)syncano {
    SCBatch *batch = [SCBatch new];
    batch.apiClient = syncano.apiClient;
    return batch;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requests = [NSMutableArray new];
    }
    return self;
}

- (void)sendWithCompletion:(SCBatchRequestCompletionBlock)completion {
    [self.apiClient POSTWithPath:@"batch/" params:[self encodedRequests] completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        if(completion) {
            completion([self handelResponse:responseObject],error);
        }
    }];
}

- (NSArray<SCBatchResponseItem *>*)handelResponse:(id)responseObject {
    NSMutableArray<SCBatchResponseItem *> *decodedItems = [NSMutableArray new];
    
    NSInteger index = 0;
    
    for (NSDictionary *item in responseObject) {
        SCBatchResponseItem *decodedItem = [SCBatchResponseItem itemWithJSONDictionary:item classToParse:[self responseObjectClassForRequestWithIndex:index]];
        [decodedItems addObject:decodedItem];
        index ++;
    }

    return [decodedItems copy];
}

- (NSDictionary *)encodedRequests {
    NSMutableArray *encodedRequests = [NSMutableArray new];
    for (SCBatchRequest *request in self.requests) {
        [encodedRequests addObject:[request encodedRequestForAPIClient:self.apiClient]];
    }
    return @{@"requests" : [encodedRequests copy]};
}

- (void)addRequest:(SCBatchRequest *)request error:(NSError **)error {
    if (self.requests.count == maxRequestsCount) {
        *error = [NSError maxRequestExceededErrorForMaxRequestNumber:maxRequestsCount];
        return;
    }
    [self.requests addObject:request];
}

- (Class)responseObjectClassForRequestWithIndex:(NSInteger)index {
    NSArray<Class> *classes = [self.requests valueForKeyPath:@"responseObjectClass"];
    if (index < classes.count) {
        return classes[index];
    } else {
        return nil;
    }
}

@end

@implementation SCBatch (SCDataObject)

- (void)addSaveRequestForDataObject:(SCDataObject *)dataObject error:(NSError *__autoreleasing *)error {
    NSError *parseError = nil;
    NSDictionary *objectJSONRepresentation = [[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:dataObject error:&parseError];
    if (parseError != nil) {
        *error = parseError;
        return;
    }
    SCBatchRequest *request = [SCBatchRequest requestWithMethod:(dataObject.objectId != nil) ? SCRequestMethodPATCH : SCRequestMethodPOST path:dataObject.path payload:objectJSONRepresentation responseObjectClass:[dataObject class]];
    NSError *addingError = nil;
    [self addRequest:request error:&addingError];
    if (error) {
        *error = addingError;
    }
}

@end

