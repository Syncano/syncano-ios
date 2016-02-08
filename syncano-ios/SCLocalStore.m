//
//  SCOfflineStore.m
//  syncano-ios
//
//  Created by Jan Lipmann on 08/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCLocalStore.h"
#import "FMDB.h"
#import "SCConstants.h"
#import "SCFileManager.h"
#import "SCDataObject+LocalStorage.h"
#import "SCParseManager+SCLocalStorage.h"
#import "NSString+JSONDictionary.h"

@interface SCLocalStore ()
@property (nonatomic,retain) FMDatabaseQueue *queue;
@end

@implementation SCLocalStore

- (void)initializeDBWithCompletionBlock:(SCCompletionBlock)completionBlock  {
    self.queue = [FMDatabaseQueue databaseQueueWithPath:[SCFileManager syncanoDBFilePath]];
    [self executeUpdateWithQuery:[SCConstants createTableSQLStatement] withCompletionBlock:^(NSError *error) {
        [self handleError:error forCompletionBlock:completionBlock];
    }];
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

- (void)deleteDataObject:(SCDataObject *)dataObject withCompletionBlock:(SCCompletionBlock)completionBlock {
    [dataObject generateDeleteQueryWithCompletion:^(NSError *error, NSString *query) {
        if (error) {
            [self handleError:error forCompletionBlock:completionBlock];
        } else {
            [self executeUpdateWithQuery:query withCompletionBlock:^(NSError *error) {
                [self handleError:error forCompletionBlock:completionBlock];
            }];
        }
    }];
}

- (void)fetchAllObjectsOfClass:(Class)objectClass withCompletionBlock:(SCDataObjectsCompletionBlock)completionBlock {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE className = '%@'",kDatabaseName,NSStringFromClass(objectClass)];
    NSMutableArray *resultObjects = [NSMutableArray new];
    [self executeQuery:query withCompletionBlock:^(FMResultSet *resultSet, NSError *error) {
        if (!error) {
            while ([resultSet next]) {
                NSString *JSONString = [resultSet objectForColumnName:@"json"];
                NSError *serializeError = nil;
                NSDictionary *JSON = [JSONString sc_jsonDictionary:&serializeError];
                NSError *parseError = nil;
                id dataObject = [[SCParseManager sharedSCParseManager] parsedObjectOfClassWithName:NSStringFromClass(objectClass) fromJSON:JSON error:&parseError];
                if (!parseError && !serializeError) {
                    if (dataObject) {
                        [resultObjects addObject:dataObject];
                    }
                }
            }
            if (completionBlock) {
                completionBlock([NSArray arrayWithArray:resultObjects],nil);
            }
        } else {
            if (completionBlock) {
                completionBlock(nil,error);
            }
        }
    }];
}

- (void)executeUpdateWithQuery:(NSString *)query withCompletionBlock:(SCCompletionBlock)completionBlock {
   
    __block NSError *error;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            [db executeUpdate:query];
            if ([db hadError]) {
                error = [db lastError];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self handleError:error forCompletionBlock:completionBlock];
        });
    });
}

- (void)executeQuery:(NSString *)query withCompletionBlock:(void(^)(FMResultSet *resultSet, NSError* error))completionBlock {
    
    __block NSError *error;
    __block FMResultSet *result;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            result = [db executeQuery:query];
            if ([db hadError]) {
                error = [db lastError];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completionBlock) {
                completionBlock(result,error);
            }
        });
    });
}

- (void)handleError:(NSError *)error forCompletionBlock:(SCCompletionBlock)completionBlock {
    if (completionBlock) {
        completionBlock(error);
    }
}

@end
