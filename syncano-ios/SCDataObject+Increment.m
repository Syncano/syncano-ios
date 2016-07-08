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
#import "NSError+SCDataObject.h"
#import "SCDataObjectProtected.h"

@implementation SCDataObject (Increment)

- (NSDictionary*)buildParametersForIncrementQueryForKeys:(NSDictionary<NSString*,NSNumber*>*)keys withError:(NSError **)error {
    
    __block NSError* internalError;
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithCapacity:(keys.count+1)];
    [keys enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSNumber * _Nonnull value, BOOL * _Nonnull stop) {
        if ([[[self class] propertyKeys] containsObject:propertyName]) {
            params[propertyName] = @{@"_increment":value};
        } else {
            *stop = YES;
            internalError = [NSError errorForUnknownProperty:propertyName];
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

- (void)fillKeys:(NSDictionary<NSString*,NSNumber*>*)keys fromResponseObject:(id)responseObject {
    [keys enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSNumber * _Nonnull value, BOOL * _Nonnull stop) {
        [self setValue:[responseObject valueForKey:propertyName] forKey:propertyName];
    }];
    self.updated_at = [[SCConstants SCDataObjectDatesTransformer] transformedValue:responseObject[@"updated_at"]];
    self.revision = responseObject[@"revision"];
}

- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    
    NSError *error = nil;
    NSDictionary* params = [self buildParametersForIncrementQueryForKeys:keys withError:&error];
    
    if(error) {
        if(completion) {
            completion(error);
        }
        return;
    }
    
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
            
            [selfWeak fillKeys:keys fromResponseObject:responseObject];
            
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
