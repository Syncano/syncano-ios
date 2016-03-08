//
//  SCUserProfile.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 07/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCUserProfile.h"
#import "SCUser+UserDefaults.h"

@interface SCDataObject (APIClient)
- (void)saveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;
@end

@implementation SCUserProfile
+ (NSString *)classNameForAPI {
    return @"user_profile";
}

- (void)saveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    if ([super respondsToSelector:@selector(saveUsingAPIClient:withCompletion:revisionMismatchValidationBlock:)]) {
        [super saveUsingAPIClient:apiClient withCompletion:^(NSError *error) {
            [SCUser updateUserProfileStoredInDefaults:self];
            if (completion) {
                completion(error);
            }
        } revisionMismatchValidationBlock:revisionMismatchBlock];
    }
}

@end
