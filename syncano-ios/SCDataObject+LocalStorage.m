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
#import "NSDictionary+JSONString.h"

@implementation SCDataObject (LocalStorage)

#pragma mark - Saving -
- (void)saveToLocalStorageWithCompletion:(SCCompletionBlock)completion {
    [[Syncano localStore] saveDataObject:self withCompletionBlock:completion];
}

#pragma mark - Fetching -
+ (void)fetchAllObjectsFromLocalStorageWithCompletionBlock:(SCDataObjectsCompletionBlock)completionBlock {
    [[Syncano localStore] fetchAllObjectsOfClass:[self class] withCompletionBlock:completionBlock];
}

#pragma mark - Delete -
- (void)deleteFromLocalStorageWithCompletion:(SCCompletionBlock)completion {
    [[Syncano localStore] deleteDataObject:self withCompletionBlock:completion];
}

#pragma mark - Helpers -
- (void)generateInsertQueryWithCompletion:(SCLocalStorageGenerateQueryStringCompletionBlock)completion {
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (className, objectId,json) VALUES ('%@',%@,'%@');",kDatabaseName,NSStringFromClass([self class]),self.objectId,[self stringRepresentation]];
    if (completion) {
        completion(nil,insertQuery);
    }
}

- (void)generateDeleteQueryWithCompletion:(SCLocalStorageGenerateQueryStringCompletionBlock)completion {
    NSString *deleteQuery = [NSString stringWithFormat:@"DELETE FROM %@ WHERE className = %@ AND objectId = %@",kDatabaseName,NSStringFromClass([self class]),self.objectId];
    if (completion) {
        completion(nil,deleteQuery);
    }
}

- (NSString *)stringRepresentation {

    NSError *dictionarySerializeError = nil;
    NSError *stringSerializeError = nil;

    NSDictionary *dictionaryRepresentation = [[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:self error:&dictionarySerializeError];
    NSString *stringRepresentation = [dictionaryRepresentation sc_jsonStringWithPrettyPrint:YES error:&stringSerializeError];
    return stringRepresentation;
}
@end