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

#pragma mark - Helpers -
- (void)generateInsertQueryWithCompletion:(void(^)(NSError *error, NSString* query))completion {
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO %@ (className, objectId,json) VALUES ('%@',%@,'%@');",kDatabaseName,NSStringFromClass([self class]),self.objectId,[self stringRepresentation]];
    if (completion) {
        completion(nil,insertQuery);
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