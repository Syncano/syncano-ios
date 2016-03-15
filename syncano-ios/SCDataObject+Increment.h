//
//  SCDataObject+Increment.h
//  syncano-ios
//
//  Created by Jakub Machoń on 04.02.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject.h"

@interface SCDataObject (Increment)
/**
 *  Increment key's value by provided number
 *
 *  @param keys                  NSDictionary with key name as a key and increment by value as a value
 *  @param apiClient             SCApiClinet to save data with
 *  @param completion            competion block
 *  @param revisionMismatchBlock result of revision mismatch verification block
 */
- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

@end
