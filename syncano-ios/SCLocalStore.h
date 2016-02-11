//
//  SCOfflineStore.h
//  syncano-ios
//
//  Created by Jan Lipmann on 08/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

@class SCDataObject;

@interface SCLocalStore : NSObject
- (void)initializeDBWithCompletionBlock:(SCCompletionBlock)completionBlock;
- (void)saveDataObject:(SCDataObject *)dataObject withCompletionBlock:(SCCompletionBlock)completionBlock;
- (void)fetchAllObjectsOfClass:(Class)objectClass withCompletionBlock:(SCDataObjectsCompletionBlock)completionBlock;
- (void)deleteDataObject:(SCDataObject *)dataObject withCompletionBlock:(SCCompletionBlock)completionBlock;
@end
