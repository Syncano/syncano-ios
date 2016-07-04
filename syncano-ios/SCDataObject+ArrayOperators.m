//
//  SCDataObject+ArrayOperators.m
//  syncano-ios
//
//  Created by Jan Lipmann on 06/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject+ArrayOperators.h"
#import "Syncano.h"
#import "SCAPIClient.h"
#import "NSError+RevisionMismatch.h"
#import "SCConstants.h"
#import "NSError+SCDataObject.h"
#import "SCDataObjectProtected.h"

typedef NS_ENUM(NSUInteger, SCDataObjectArrayOperator) {
    SCDataObjectArrayOperatorAdd,
    SCDataObjectArrayOperatorAddUnique,
    SCDataObjectArrayOperatorRemove,
};

@implementation SCDataObject (ArrayOperators)

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion {
    [self addArrayOfObjects:array forArrayWithKey:key withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion {
    [self addUniqueArrayOfObjects:array forArrayWithKey:key withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion {
    [self removeArrayOfObjects:array fromArrayWithKey:key withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion {
    [self addArrayOfObjects:array forArrayWithKey:key forSyncano:syncano withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion {
    [self addUniqueArrayOfObjects:array forArrayWithKey:key forSyncano:syncano withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion {
    [self removeArrayOfObjects:array fromArrayWithKey:key forSyncano:syncano withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion {
    [self addArrayOfObjects:array forArrayWithKey:key usingAPIClient:apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion {
    [self addUniqueArrayOfObjects:array forArrayWithKey:key usingAPIClient:apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion {
    [self removeArrayOfObjects:array fromArrayWithKey:key usingAPIClient:apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self addArrayOfObjects:array forArrayWithKey:key usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self addUniqueArrayOfObjects:array forArrayWithKey:key usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self removeArrayOfObjects:array fromArrayWithKey:key usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self addArrayOfObjects:array forArrayWithKey:key usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self addUniqueArrayOfObjects:array forArrayWithKey:key usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self removeArrayOfObjects:array fromArrayWithKey:key usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    NSError *error = nil;
    NSDictionary* params = [self buildParametersForOperator:SCDataObjectArrayOperatorAdd withArrayOfObjects:array forKey:key withRevisionMismatchCheck:(revisionMismatchBlock != nil) withError:&error];
    
    if(error) {
        if(completion) {
            completion(error);
        }
        return;
    }
    
    [self saveArrayForKey:key params:params apiClient:apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];

}
- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock{
    NSError *error = nil;
    NSDictionary* params = [self buildParametersForOperator:SCDataObjectArrayOperatorAddUnique withArrayOfObjects:array forKey:key withRevisionMismatchCheck:(revisionMismatchBlock != nil) withError:&error];
    
    if(error) {
        if(completion) {
            completion(error);
        }
        return;
    }
    
    [self saveArrayForKey:key params:params apiClient:apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    NSError *error = nil;
    NSDictionary* params = [self buildParametersForOperator:SCDataObjectArrayOperatorRemove withArrayOfObjects:array forKey:key withRevisionMismatchCheck:(revisionMismatchBlock != nil) withError:&error];
    
    if(error) {
        if(completion) {
            completion(error);
        }
        return;
    }
    
    [self saveArrayForKey:key params:params apiClient:apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (NSDictionary *)buildParametersForOperator:(SCDataObjectArrayOperator)operator withArrayOfObjects:(NSArray *)array forKey:(NSString *)key withRevisionMismatchCheck:(BOOL)revisionMismatchCheck withError:(NSError **)error {
    __block NSError* internalError;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([[[self class] propertyKeys] containsObject:key]) {
        params[key] = @{[self stringRepresentationForArrayOperator:operator]:array};
    } else {
        internalError = [NSError errorForUnknownProperty:key];
    }
    if (revisionMismatchCheck && self.revision) {
        params[kExpectedRevisionRequestParam] = self.revision;
    }
    
    if(internalError) {
        *error = internalError;
        return nil;
    }
    return params;
}

- (NSString *)stringRepresentationForArrayOperator:(SCDataObjectArrayOperator)operator {
    switch (operator) {
        case SCDataObjectArrayOperatorAdd:
            return @"_add";
            break;
        case SCDataObjectArrayOperatorAddUnique:
            return @"_addunique";
            break;
        case SCDataObjectArrayOperatorRemove:
            return @"_remove";
            break;
        default:
            return nil;
            break;
    }
}

- (void)fillKey:(NSString *)key fromResponseObject:(id)responseObject {
    [self setValue:[responseObject valueForKey:key] forKey:key];
    self.updated_at = [[SCConstants SCDataObjectDatesTransformer] transformedValue:responseObject[@"updated_at"]];
    self.revision = responseObject[@"revision"];
}

- (void)saveArrayForKey:(NSString *)key params:(NSDictionary *)params apiClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self saveMeIfNeededWithAPIClient:apiClient completion:^(NSError * _Nullable error) {
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
            
            [selfWeak fillKey:key fromResponseObject:responseObject];
            
            if(completion) {
                completion(nil);
            }
            if(revisionMismatchBlock) {
                revisionMismatchBlock(NO,nil);
            }
        }];
    }];
}
@end
