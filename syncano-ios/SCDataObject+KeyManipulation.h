//
//  SCDataObject+KeyManipulation.h
//  syncano-ios
//
//  Created by Jan Lipmann on 08/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDataObject (KeyManipulation)
- (void)saveObjectAfterManipulationOfKey:(NSString *)key params:(NSDictionary *)params apiClient:(SCAPIClient *)apiClient withCompletion:(nullable SCKeyManipulationCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;
@end

NS_ASSUME_NONNULL_END