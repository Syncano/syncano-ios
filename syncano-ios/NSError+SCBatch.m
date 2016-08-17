//
//  NSError+SCBatch.m
//  syncano-ios
//
//  Created by Jan Lipmann on 03/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "NSError+SCBatch.h"
#import "SCConstants.h"

@implementation NSError (SCBatch)
+ (NSError*)maxRequestExceededError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey:  NSLocalizedString(@"Number of requests in batch exceeded",@""),
                               NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"You cannot add more than %@ requests to batch.",@""),@(maxBatchRequestsCount)],
                               };
    return [NSError errorWithDomain:SCBatchErrorDomain  code:SCErrorCodeBatchNumberOfRequestsExceeded userInfo:userInfo];
}
@end
