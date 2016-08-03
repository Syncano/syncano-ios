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
+ (NSError*)maxRequestExceededErrorForMaxRequestNumber:(NSInteger)max {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey:  NSLocalizedString(@"Number of requests in batch exceeded",@""),
                               NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedString(@"You cannot add more than %@ requests to batch.",@""),@(max)],
                               };
    return [NSError errorWithDomain:SCBatchErrorDomain  code:SCErrorCodeBatchNumberOfRequestsExceeded userInfo:userInfo];
}
@end
