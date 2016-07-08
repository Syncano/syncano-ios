//
//  SCDataObjectProtected.h
//  syncano-ios
//
//  Created by Jan Lipmann on 04/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@class SCAPIClient;

@interface SCDataObject ()
- (void)saveMeIfNeededWithAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion;
@end

NS_ASSUME_NONNULL_END