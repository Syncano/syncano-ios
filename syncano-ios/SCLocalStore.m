//
//  SCOfflineStore.m
//  syncano-ios
//
//  Created by Jan Lipmann on 08/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCLocalStore.h"
#import <FMDB.h>
#import "SCConstants.h"
#import "SCDataObject+LocalStorage.h"

@interface SCLocalStore ()
@property (nonatomic,retain) FMDatabase *db;
@end

@implementation SCLocalStore

- (void)initializeDBWithCompletionBlock:(SCCompletionBlock)completionBlock  {
    self.db = [FMDatabase databaseWithPath:[SCConstants DB_PATH]];
    if (self.db) {
        [self executeUpdateWithQuery:[SCConstants createTableSQLStatement] withCompletionBlock:^(NSError *error) {
            [self handleError:error forCompletionBlock:completionBlock];
        }];
    } else {
        
        NSError *error = [NSError errorWithDomain:@"SCLocalStoreErrorDomain" code:1 userInfo:@{@"SyncanoLocalStoreErrorDescription" : @"Could not initialize database"}];
        [self handleError:error forCompletionBlock:completionBlock];
    }

}

- (void)saveDataObject:(SCDataObject *)dataObject withCompletionBlock:(SCCompletionBlock)completionBlock {
    [dataObject generateInsertQueryWithCompletion:^(NSError *error, NSString *query) {
        if (error) {
            [self handleError:error forCompletionBlock:completionBlock];
        } else {
            [self executeUpdateWithQuery:query withCompletionBlock:^(NSError *error) {
                [self handleError:error forCompletionBlock:completionBlock];
            }];
        }
    }];
}


- (void)openDatabaseWithCompletionBlock:(SCCompletionBlock)completionBlock {
    if ([self.db open]) {
        [self handleError:nil forCompletionBlock:completionBlock];
    } else {
        [self handleError:[self.db lastError] forCompletionBlock:completionBlock];
    }
}

- (void)closeDataBaseWithCompletionBlock:(SCCompletionBlock)completionBlock {
    if ([self.db close]) {
        [self handleError:nil forCompletionBlock:completionBlock];
    } else {
        [self handleError:[self.db lastError] forCompletionBlock:completionBlock];
    }
}

- (void)executeUpdateWithQuery:(NSString *)query withCompletionBlock:(SCCompletionBlock)completionBlock {
   [self openDatabaseWithCompletionBlock:^(NSError *error) {
       if (!error) {
           NSError *executeError;
           [self.db beginTransaction];
           
           if (![self.db executeUpdate:query]) {
               executeError = [self.db lastError];
           }
           
           if (executeError) {
               [self.db rollback];
               [self handleError:executeError forCompletionBlock:completionBlock];
           } else {
               [self.db commit];
               [self closeDataBaseWithCompletionBlock:^(NSError *error) {
                   [self handleError:error forCompletionBlock:completionBlock];
               }];
           }
       } else {
           [self handleError:error forCompletionBlock:completionBlock];
       }
   }];
}

- (void)handleError:(NSError *)error forCompletionBlock:(SCCompletionBlock)completionBlock {
    if (completionBlock) {
        completionBlock(error);
    }
}

@end
