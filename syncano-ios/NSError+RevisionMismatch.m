//
//  NSError+RevisionMismatch.m
//  syncano-ios
//
//  Created by Jan Lipmann on 15/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "NSError+RevisionMismatch.h"
#import "SCConstants.h"

@implementation NSError (RevisionMismatch)
- (void)checkIfMismatchOccuredWithCompletion:(SCDataObjectRevisionMismatchCompletionBlock)completionBlock {
    NSDictionary *syncanoErroInfo = self.userInfo[kSyncanoRepsonseErrorKey];
    NSString *expectedRevisionDescription = syncanoErroInfo[kReviosionMismatchResponseError];
    BOOL mismatched = NO;
    if (expectedRevisionDescription) {
        mismatched = YES;
    }
    if (completionBlock) {
        completionBlock(mismatched,expectedRevisionDescription);
    }
}
@end
