//
//  SCDataObject+KeyManipulation.m
//  syncano-ios
//
//  Created by Jan Lipmann on 08/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject+KeyManipulation.h"
#import "SCDataObjectProtected.h"
#import "SCAPIClient+SCDataObject.h"
#import "NSError+RevisionMismatch.h"

@implementation SCDataObject (KeyManipulation)
- (void)saveObjectAfterManipulationOfKey:(NSString *)key params:(NSDictionary *)params apiClient:(SCAPIClient *)apiClient withCompletion:(nullable SCKeyManipulationCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self saveMeIfNeededWithAPIClient:apiClient completion:^(NSError * _Nullable error) {
        [apiClient PATCHWithPath:[self path] params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            if(error) {
                if(completion) {
                    completion(key,nil,error);
                }
                if(revisionMismatchBlock) {
                    [error checkIfMismatchOccuredWithCompletion:revisionMismatchBlock];
                }
                return;
            }
            
            //[selfWeak fillKey:key fromResponseObject:responseObject];
            
            if(completion) {
                completion(key,responseObject,nil);
            }
            if(revisionMismatchBlock) {
                revisionMismatchBlock(NO,nil);
            }
        }];
    }];
}

@end
