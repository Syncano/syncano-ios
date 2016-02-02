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
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSDictionary *syncanoErrorInfo = self.userInfo[kSyncanoResponseErrorKey];
        NSString *expectedRevisionDescription = syncanoErrorInfo[kRevisionMismatchResponseError];
        BOOL mismatched = NO;
        if (expectedRevisionDescription) {
            mismatched = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completionBlock) {
                completionBlock(mismatched,expectedRevisionDescription);
            }
        });
    });
    

}
@end
