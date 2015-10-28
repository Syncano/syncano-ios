//
//  SCDataObject+LocalStorage.m
//  syncano-ios
//
//  Created by Jan Lipmann on 28/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCDataObject+LocalStorage.h"
#import "SCParseManager+SCDataObject.h"
#import "Syncano.h"
#import "SCLocalStore.h"

@implementation SCDataObject (LocalStorage)

#pragma mark - Saving -
- (void)saveToLocalStorageWithCompletion:(SCCompletionBlock)completion {
    [[Syncano localStore] saveDataObject:self withCompletionBlock:completion];
}

#pragma mark - Helpers -
- (void)generateInsertQueryWithCompletion:(void(^)(NSError *error, NSString* query))completion {
    NSError *error;
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO SyncanoDataObjects (className, objectId,json) VALUES ('%@',%@,%@);",NSStringFromClass([self class]),self.objectId,[[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:self error:&error]];
    if (completion) {
        completion(error,insertQuery);
    }
}
@end