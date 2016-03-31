//
//  SCReferenceStoreManager.m
//  syncano-ios
//
//  Created by Jan Lipmann on 03/03/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCReferencesStore.h"
#import "SCDataObject.h"

@interface SCReferencesStore ()
@property (nonatomic,retain) NSMapTable *store;
@end

@implementation SCReferencesStore

- (instancetype)init {
    self = [super init];
    if (self) {
        self.store = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory capacity:0];
    }
    return self;
}

- (void)addDataObject:(SCDataObject *)dataObject {
    if (dataObject.objectId == nil) {
        return;
    }
    [self.store setObject:dataObject forKey:dataObject.objectId];
}

- (SCDataObject *)getObjectById:(NSNumber *)objectId {
    return [self.store objectForKey:objectId];
}

@end
