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

@interface SCBatch ()
@property (nonatomic,retain) NSMutableArray *requests;
@end

@implementation SCBatch

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requests = [NSMutableArray new];
    }
    return self;
}

- (void)addSaveRequestForDataObject:(SCDataObject *)dataObject withCompletion:(SCCompletionBlock)completion {
    NSError *parseError;
    NSDictionary *objectJSONRepresentation = [[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:dataObject error:&parseError];
    if (parseError != nil) {
        if (completion) {
            completion(parseError);
        }
    }
    SCBatchRequest *request = [SCBatchRequest new];
    request.payload = objectJSONRepresentation;
    request.method = (dataObject.objectId != nil) ? SCRequestMethodPATCH : SCRequestMethodPOST;
    request.callback = completion;
    [self.requests addObject:request];
}

- (void)send {
    
}
@end
