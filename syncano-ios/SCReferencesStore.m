//
//  SCReferenceStoreManager.m
//  syncano-ios
//
//  Created by Jan Lipmann on 03/03/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCReferencesStore.h"
#import "SCDataObject.h"

@implementation SCReferencesStore

- (void)addDataObject:(SCDataObject *)dataObject {
    [self setObject:dataObject forKey:dataObject.objectId];
}

- (SCDataObject *)getObjectById:(NSNumber *)objectId {
    return [self objectForKey:objectId];
}

@end
