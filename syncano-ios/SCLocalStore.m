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

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeDB];
    }
    return self;
}

- (void)initializeDB {
    _db = [FMDatabase databaseWithPath:[SCConstants DB_PATH]];
    [_db open];
    [_db executeUpdate:[SCConstants createTableSQLStatement]];
    [_db close];
}

- (void)saveDataObject:(SCDataObject *)dataObject withCompletionBlock:(SCCompletionBlock)completionBlock {
    if ([_db open]) {
        [dataObject generateInsertQueryWithCompletion:^(NSError *error, NSString *query) {
            if (!error) {
                [_db beginTransaction];
                [_db executeUpdate:query];
                [_db  commit];
            }
            [_db close];
            if (completionBlock) {
                completionBlock(error);
            }
        }];
    }
}


@end
