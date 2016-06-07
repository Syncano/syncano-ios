//
//  SCDataObject+ArrayOperators.m
//  syncano-ios
//
//  Created by Jan Lipmann on 06/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject+ArrayOperators.h"
#import "SCAPIClient.h"
#import "NSError+RevisionMismatch.h"
#import "SCConstants.h"
#import "NSError+SCDataObject.h"

typedef NS_ENUM(NSUInteger, SCDataObjectArrayOperator) {
    SCDataObjectArrayOperatorAdd,
    SCDataObjectArrayOperatorAddUnique,
    SCDataObjectArrayOperatorRemove,
};

@implementation SCDataObject (ArrayOperators)

- (NSDictionary *)buildParametersForOperator:(SCDataObjectArrayOperator)operator withArrayOfObjects:(NSArray *)array forKey:(NSString *)key withError:(NSError **)error {
    __block NSError* internalError;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([[[self class] propertyKeys] containsObject:key]) {
        params[key] = @{[self stringRepresentationForArrayOperator:operator]:array};
    } else {
        internalError = [NSError errorForUnknownProperty:key];
    }
    if (self.revision) {
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
}

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    NSError *error = nil;
    NSDictionary* params = [self buildParametersForOperator:SCDataObjectArrayOperatorAdd withArrayOfObjects:array forKey:key withError:&error];
    
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
    NSDictionary* params = [self buildParametersForOperator:SCDataObjectArrayOperatorAddUnique withArrayOfObjects:array forKey:key withError:&error];
    
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
    NSDictionary* params = [self buildParametersForOperator:SCDataObjectArrayOperatorRemove withArrayOfObjects:array forKey:key withError:&error];
    
    if(error) {
        if(completion) {
            completion(error);
        }
        return;
    }
    
    [self saveArrayForKey:key params:params apiClient:apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
@end
