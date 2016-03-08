//
//  SCReferenceStoreManager.h
//  syncano-ios
//
//  Created by Jan Lipmann on 03/03/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCDataObject;

@interface SCReferencesStore : NSMapTable
- (void)addDataObject:(SCDataObject *)dataObject;
- (SCDataObject *)getObjectById:(NSNumber *)objectId;
@end
