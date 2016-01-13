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
    NSString *library = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSString *privateDocuments = [library stringByAppendingPathComponent:@"Private Documents"];
    NSString *syncanoDocumentsDir = [privateDocuments stringByAppendingPathComponent:_SyncanoDocumentsDirectoryName];
    [self createDirectoryIfNeededAtPath:syncanoDocumentsDir completionBlock:nil];
    return syncanoDocumentsDir;
}

#pragma mark - Database -
+ (NSString *)syncanoDBFilePath {
    NSString *dbPath = [[self syncanoDocumentsDirectoryPath] stringByAppendingPathComponent:_SyncanoDBFileName];
    return dbPath;
}


+ (void)createDirectoryIfNeededAtPath:(NSString *)path completionBlock:(SCCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSError *creationError;
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&creationError];
            
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completionBlock) {
                completionBlock(creationError);
            }
        });
    });
}
@end

@implementation SCFileManager (Request)

+ (void)writeAsyncRequest:(SCRequest *)request queueIdentifier:(NSString *)queueIdentifier completionBlock:(SCCompletionBlock)completionBlock {
    
    NSString *fileName = [NSString stringWithFormat:@"%@.plist",request.identifier];
    NSString *dirPath = [[self syncanoDocumentsDirectoryPath] stringByAppendingPathComponent:queueIdentifier];
    NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
    
    [self createDirectoryIfNeededAtPath:dirPath completionBlock:^(NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                
                NSError *serializationError;
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:[request dictionaryRepresentation]
                                                               options:0
                                                                 error:&serializationError];
                if (!serializationError) {
                    NSError *savingError;
                    [data writeToFile:filePath options:NSDataWritingAtomic error:&savingError];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        if (completionBlock) {
                            completionBlock(savingError);
                        }
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        if (completionBlock) {
                            completionBlock(serializationError);
                        }
                    });
                }
            });
        }
    }];
    
    
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