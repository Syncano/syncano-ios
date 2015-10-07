//
//  SCSQLiteDatabase.m
//  syncano-ios
//
//  Created by Jan Lipmann on 06/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCSQLiteDatabase.h"

#import <sqlite3.h>

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

- (void)open {
    //TODO: needs implementation
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
