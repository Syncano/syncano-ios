//
//  SCFileManager.m
//  syncano-ios
//
//  Created by Jan Lipmann on 05/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCFileManager.h"

static NSString *const _SyncanoDBFileName = @"Syncano.db";
static NSString *const _SyncanoDocumentsDirectoryName = @"Syncano";
@implementation SCFileManager

#pragma mark - Storage -
+ (NSString *)syncanoDocumentsDirectoryPath {
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *syncanoDocumentsDir = [documentsDir stringByAppendingPathComponent:_SyncanoDocumentsDirectoryName];
    [self createDirectoryIfNeededAtPath:syncanoDocumentsDir];
    return syncanoDocumentsDir;
}

#pragma mark - Database -
+ (NSString *)syncanoDBFilePath {
    NSString *dbPath = [[self syncanoDBFilePath] stringByAppendingPathComponent:_SyncanoDBFileName];
    return dbPath;
}

+ (void)createDirectoryIfNeededAtPath:(NSString *)path {
    [self createDirectoryIfNeededAtPath:path error:nil];
}

+ (void)createDirectoryIfNeededAtPath:(NSString *)path error:(NSError **)error {
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *_error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&_error];
        *error = _error;
    }
}
@end
