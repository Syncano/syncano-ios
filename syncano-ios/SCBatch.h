//
//  SCBatch.h
//  syncano-ios
//
//  Created by Jan Lipmann on 01/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class Syncano,SCDataObject;

@interface SCBatch : NSObject

+ (SCBatch *)batch;
+ (SCBatch *)batchForSyncano:(Syncano *)syncano;

- (void)sendWithCompletion:(SCBatchRequestCompletionBlock)completion;

- (void)addSaveRequestForDataObject:(SCDataObject *)dataObject error:(NSError **)error;

@end
