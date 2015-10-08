//
//  SCOfflineStore.m
//  syncano-ios
//
//  Created by Jan Lipmann on 08/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCLocalStore.h"

@implementation SCLocalStore

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureDB];
    }
    return self;
}

- (void)configureDB {
    //TODO: Here we have to create new db using FMDB
}

- (void)saveDataObject:(SCDataObject *)dataObject withCompletionBlock:(SCCompletionBlock)completionBlock {
    
}

@end
