//
//  NSError+RevisionMismatch.h
//  syncano-ios
//
//  Created by Jan Lipmann on 15/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@interface NSError (RevisionMismatch)
- (void)checkIfMismatchOccuredWithCompletion:(nullable SCDataObjectRevisionMismatchCompletionBlock)completionBlock;
@end
