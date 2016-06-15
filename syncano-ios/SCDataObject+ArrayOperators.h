//
//  SCDataObject+ArrayOperators.h
//  syncano-ios
//
//  Created by Jan Lipmann on 06/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject.h"

NS_ASSUME_NONNULL_BEGIN

@class Syncano;

@interface SCDataObject (ArrayOperators)

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion;

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion;

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion;

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion;

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion;

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion;







- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key forSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)addArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)addUniqueArrayOfObjects:(NSArray*)array forArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)removeArrayOfObjects:(NSArray *)array fromArrayWithKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;
@end
NS_ASSUME_NONNULL_END
