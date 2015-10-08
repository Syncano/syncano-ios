//
//  SCSQLiteDatabase.m
//  syncano-ios
//
//  Created by Jan Lipmann on 06/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCSQLiteDatabase.h"

#import <sqlite3.h>

static NSString * const kSQLiteDatabaseErrorDomain = @"SQLiteDatabase";


int const SQLiteDatabaseAlreadyOpened = 3;


@interface SCSQLiteDatabase ()
@property (nonatomic, assign) sqlite3 *database;
@property (nonatomic,retain) NSString *dbPath;
@end

@implementation SCSQLiteDatabase

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _dbPath = path;
    }
    return self;
}

- (void)openWithCompletionBlock:(void (^)(NSError *))block {
    if (self.database) {
        
        if (block) {
            NSError *error = [NSError errorWithDomain:kSQLiteDatabaseErrorDomain code:SQLiteDatabaseAlreadyOpened userInfo:@{@"message" : @"Database is already opened"}];
            block(error);
        }
        return;
    }
    
    sqlite3 *db;
    int resultCode = sqlite3_open([self.dbPath UTF8String], &db);
    if (resultCode != SQLITE_OK) {
        if (block) {
            NSError *error = [NSError errorWithDomain:kSQLiteDatabaseErrorDomain code:resultCode userInfo:@{@"message" : [NSString stringWithUTF8String:sqlite3_errmsg(db)]}];
            block(error);
        }
    }
    self.database = db;
}

- (void)close {
    //TODO: needs implementation
}

- (void)beginTransaction {
    //TODO: needs implementation
}

- (void)commit {
    //TODO: needs implementation
}

- (void)rollback {
    //TODO: needs implementation
}

@end
