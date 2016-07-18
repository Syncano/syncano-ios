//
//  SCDataObject+RelationOperators.m
//  syncano-ios
//
//  Created by Jan Lipmann on 14/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "Syncano.h"
#import "SCDataObject+RelationOperators.h"
#import "NSError+SCDataObject.h"
#import "SCAPIClient+SCDataObject.h"
#import "NSError+RevisionMismatch.h"
#import "SCRegisterManager.h"
#import "SCDataObject+KeyManipulation.h"

typedef NS_ENUM(NSUInteger, SCDataObjectRelationOperator) {
    SCDataObjectRelationOperatorAdd,
    SCDataObjectRelationOperatorRemove
};

@implementation SCDataObject (RelationOperators)

- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion  {
    [self addMembers:members forRelationWithKey:relationKey withCompletion:completion revisionMismatchValidationBlock:nil];
}
- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion {
    [self removeMembers:members fromRelationWithKey:relationKey withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self addMembers:members forRelationWithKey:relationKey usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    
}

- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion {
    [self addMembers:members forRelationWithKey:relationKey usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}
- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion {
    [self removeMembers:members fromRelationWithKey:relationKey usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self addMembers:members forRelationWithKey:relationKey usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self removeMembers:members fromRelationWithKey:relationKey usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
        NSArray *membersIds = [members valueForKeyPath:@"objectId"];
        NSError *error = nil;
        NSDictionary* params = [self buildParametersForOperator:SCDataObjectRelationOperatorAdd withArrayOfObjects:membersIds forKey:relationKey withRevisionMismatchCheck:(revisionMismatchBlock != nil) withError:&error];
        
        if(error) {
            if(completion) {
                completion(error);
            }
            return;
        }
        
        [self saveRelationForKey:relationKey params:params apiClient:apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    NSArray *membersIds = [members valueForKeyPath:@"objectId"];
    NSError *error = nil;
    NSDictionary* params = [self buildParametersForOperator:SCDataObjectRelationOperatorRemove withArrayOfObjects:membersIds forKey:relationKey withRevisionMismatchCheck:(revisionMismatchBlock != nil) withError:&error];
    
    if(error) {
        if(completion) {
            completion(error);
        }
        return;
    }
    
    [self saveRelationForKey:relationKey params:params apiClient:apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (NSDictionary *)buildParametersForOperator:(SCDataObjectRelationOperator)operator withArrayOfObjects:(NSArray *)array forKey:(NSString *)key withRevisionMismatchCheck:(BOOL)revisionMismatchCheck withError:(NSError **)error {
    __block NSError* internalError;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:1];
    if ([[[self class] propertyKeys] containsObject:key]) {
        params[key] = @{[self stringRepresentationForRelationOperator:operator]:array};
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

- (NSString *)stringRepresentationForRelationOperator:(SCDataObjectRelationOperator)operator {
    switch (operator) {
        case SCDataObjectRelationOperatorAdd:
            return @"_add";
            break;
        case SCDataObjectRelationOperatorRemove:
            return @"_remove";
            break;
        default:
            return nil;
            break;
    }
}

- (void)fillKey:(NSString *)key fromResponseObject:(id)responseObject {
    NSDictionary *relationObject = [responseObject valueForKey:key];
    NSString *relationTarget = relationObject[@"target"];
    Class relationTargetClass = [SCRegisterManager classForAPIClassName:relationTarget];
    SCRelation *relation = [[SCRelation alloc] initWithDictionary:[responseObject valueForKey:key] error:nil targetClass:relationTargetClass];
    [self setValue:relation forKey:key];
    self.updated_at = [[SCConstants SCDataObjectDatesTransformer] transformedValue:responseObject[@"updated_at"]];
    self.revision = responseObject[@"revision"];
}

- (void)saveRelationForKey:(NSString *)key params:(NSDictionary *)params apiClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    typeof(self) __weak selfWeak = self;
    [self saveObjectAfterManipulationOfKey:key params:params apiClient:apiClient withCompletion:^(NSString * _Nonnull key, id  _Nullable responseObject, NSError * _Nullable error) {
        [selfWeak fillKey:key fromResponseObject:responseObject];
        if (completion) {
            completion(error);
        }
    } revisionMismatchValidationBlock:revisionMismatchBlock];
}


@end
