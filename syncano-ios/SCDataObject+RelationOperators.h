//
//  SCDataObject+RelationOperators.h
//  syncano-ios
//
//  Created by Jan Lipmann on 14/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject.h"
#import "SCConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class SCDataObject,Syncano;

@interface SCDataObject (RelationOperators)

#pragma mark - shared Syncano instance methods -
- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion;
- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion;

- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;
- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

#pragma mark - custom Syncano instance methods -
- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;
- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

- (void)addMembers:(NSArray<SCDataObject *>*)members forRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;
- (void)removeMembers:(NSArray<SCDataObject *>*)members fromRelationWithKey:(NSString *)relationKey forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;
@end
NS_ASSUME_NONNULL_END
