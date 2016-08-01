//
//  SCBatch.h
//  syncano-ios
//
//  Created by Jan Lipmann on 01/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class SCDataObject;

@interface SCBatch : NSObject

- (void)send;

- (void)addSaveRequestForDataObject:(SCDataObject *)dataObject withCompletion:(SCCompletionBlock)completion;

@end
