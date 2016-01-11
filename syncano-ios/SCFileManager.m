//
//  SCFileManager.m
//  syncano-ios
//
//  Created by Jan Lipmann on 05/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCFileManager.h"
#import "SCRequest.h"

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

@implementation SCFileManager (Request)

+ (void)writeAsyncRequest:(SCRequest *)request queueIdentifier:(NSString *)queueIdentifier completionBlock:(SCCompletionBlock)completionBlock {
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",request.identifier];
    NSString *dirPath = [[self syncanoDocumentsDirectoryPath] stringByAppendingPathComponent:queueIdentifier];
    NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSError *error;
        [self createDirectoryIfNeededAtPath:dirPath error:&error];
        if (!error) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:[request dictionaryRepresentation]
                                                                   options:0
                                                                     error:&error];
            if (!error) {
                [data writeToFile:filePath options:NSDataWritingAtomic error:&error];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completionBlock) {
                completionBlock(error);
            }
        });
    });
}

+ (void)removeAsyncRequest:(SCRequest *)request queueIdentifier:(NSString *)queueIdentifier completionBlock:(SCCompletionBlock)completionBlock {
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",request.identifier];
    NSString *dirPath = [[self syncanoDocumentsDirectoryPath] stringByAppendingPathComponent:queueIdentifier];
    NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        [fileManager removeItemAtPath:filePath error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completionBlock) {
                completionBlock(error);
            }
        });
    });
}

+ (void)findAllRequestArchivesForQueueWithIdentifier:(NSString *)queueIdentifier completionBlock:(SCFindRequestsCompletionBlock)completionBlock {
    NSString *dirPath = [[self syncanoDocumentsDirectoryPath] stringByAppendingPathComponent:queueIdentifier];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        BOOL directoryExists = [fileManager fileExistsAtPath:dirPath];
        if (directoryExists) {
                NSError *error;
                NSArray *files = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        if (completionBlock) {
                            completionBlock(nil,error);
                        }
                    });
                } else {
                NSPredicate *plistFilter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"];
                NSArray *plistFiles = [files filteredArrayUsingPredicate:plistFilter];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        if (completionBlock) {
                            completionBlock(plistFiles,error);
                        }
                    });
                }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (completionBlock) {
                    completionBlock(nil,nil);
                }
            });
        }
    });
}

+ (BOOL)directoryExistsForQueueIdentifier:(NSString *)queueIdentifier {
    return YES;
}

@end