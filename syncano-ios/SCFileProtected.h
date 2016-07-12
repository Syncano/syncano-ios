//
//  SCFileProtected.h
//  syncano-ios
//
//  Created by Mariusz Wisniewski on 11/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN

@class SCAPIClient;

@interface SCFile ()
- (void)saveAsPropertyWithName:(NSString *)name ofDataObject:(SCDataObject *)dataObject usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion;
@end

NS_ASSUME_NONNULL_END