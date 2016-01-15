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
    if (self.userInfo[kSyncanoRepsonseErrorKey]) {
        NSDictionary *syncanoErroInfo = self.userInfo[kSyncanoRepsonseErrorKey];
        BOOL mismatched = NO;
        NSString *description;
        if (syncanoErroInfo[@"expected_revision"]) {
            mismatched = YES;
            description = syncanoErroInfo[@"expected_revision"];
        }
        if (completionBlock) {
            completionBlock(mismatched,description);
        }
    } else {
        if (completionBlock) {
            completionBlock(NO,nil);
        }
    }
}
@end
