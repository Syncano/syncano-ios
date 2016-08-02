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

- (void)addSaveRequestForDataObject:(SCDataObject *)dataObject error:(NSError *__autoreleasing *)error {
    NSError *parseError;
    NSDictionary *objectJSONRepresentation = [[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:dataObject error:&parseError];
    *error = parseError;
    SCBatchRequest *request = [SCBatchRequest requestWithMethod:(dataObject.objectId != nil) ? SCRequestMethodPATCH : SCRequestMethodPOST path:dataObject.path payload:objectJSONRepresentation];
    [self.requests addObject:request];
}

- (void)sendWithCompletion:(SCBatchRequestCompletionBlock)completion {
    [self.apiClient POSTWithPath:@"batch/" params:[self encodedRequests] completion:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject, NSError * _Nullable error) {
        if(completion) {
            completion(responseObject,error);
        }
    }];
}

- (NSDictionary *)encodedRequests {
    NSMutableArray *encodedRequests = [NSMutableArray new];
    for (SCBatchRequest *request in self.requests) {
        [encodedRequests addObject:[request encodedRequestForAPIClient:self.apiClient]];
    }
    return @{@"requests" : [encodedRequests copy]};
}
@end
