//
//  NSError+RevisionMismatch.h
//  syncano-ios
//
//  Created by Jan Lipmann on 15/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"
NS_ASSUME_NONNULL_BEGIN
@interface NSError (RevisionMismatch)
- (void)checkIfMismatchOccuredWithCompletion:(SCDataObjectRevisionMismatchCompletionBlock)completionBlock;
@end
NS_ASSUME_NONNULL_END