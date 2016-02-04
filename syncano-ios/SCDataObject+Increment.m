//
//  SCDataObject+Increment.m
//  syncano-ios
//
//  Created by Jakub Machoń on 04.02.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject+Increment.h"
#import "SCAPIClient.h"
#import "NSError+RevisionMismatch.h"

@implementation SCDataObject (Increment)

- (NSError*)errorForUnknownProperty:(NSString*)propertyName {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"Property %@ does not exist", @""),propertyName],
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"You change value of non-existing property.",@""),
                               };
    return [NSError errorWithDomain:SCDataObjectErrorDomain  code:SCErrorCodeDataObjectNonExistingPropertyName userInfo:userInfo];
}

- (NSDictionary*)buildParametrsForIncrementQueryForValues:(NSDictionary<NSString*,NSNumber*>*)values withError:(NSError *__autoreleasing *)error {
    
    __block NSError* internalError;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:(values.count+1)];
    [values enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSNumber * _Nonnull value, BOOL * _Nonnull stop) {
        if ([[[self class] propertyKeys] containsObject:propertyName]) {
            params[propertyName] = @{@"_increment":value};
        } else {
            *stop = YES;
            internalError = [self errorForUnknownProperty:propertyName];
        }
    }];
    if (self.revision) {
        params[kExpectedRevisionRequestParam] = self.revision;
    }
    
    if(internalError) {
        *error = internalError;
        return nil;
    }
    return params;
}

- (void)fillValues:(NSDictionary<NSString*,NSNumber*>*)values fromResponseObject:(id)responseObject {
    [values enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSNumber * _Nonnull value, BOOL * _Nonnull stop) {
        [self setValue:[responseObject valueForKey:propertyName] forKey:propertyName];
    }];
    self.updated_at = responseObject[@"updated_at"];
    self.revision = responseObject[@"revision"];
}

- (void)incrementValues:(NSDictionary<NSString*,NSNumber*>*)values usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    
    NSError *error = nil;
    NSDictionary* params = [self buildParametrsForIncrementQueryForValues:values withError:&error];
    
    if(error) {
        if(completion) {
            completion(error);
        }
        return;
    }
    
    typeof(self) __weak selfWeak = self;
    [apiClient PATCHWithPath:[self path] params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if(error) {
            if(completion) {
                completion(error);
            }
            if(revisionMismatchBlock) {
                [error checkIfMismatchOccuredWithCompletion:revisionMismatchBlock];
            }
            return;
        }
        
        [selfWeak fillValues:values fromResponseObject:responseObject];
        
        if(completion) {
            completion(nil);
        }
        if(revisionMismatchBlock) {
            revisionMismatchBlock(NO,nil);
        }
    }];
    
}


@end
