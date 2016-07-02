//
//  SCDataObject.m
//  syncano-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCDataObject.h"
#import "Mantle/Mantle.h"
#import "SCAPIClient+SCDataObject.h"
#import "Syncano.h"
#import "SCParseManager.h"
#import "SCPlease.h"
#import "SCPleaseForView.h"
#import "SCPleaseForDataEndpoint.h"
#import "SCPleaseForTemplate.h"
#import "SCDataObject+Properties.h"
#import "SCDataObject+Increment.h"
#import "SCRegisterManager.h"
#import "NSError+RevisionMismatch.h"

@implementation SCDataObject

+ (NSString *)classNameForAPI {
    NSString *className = [NSStringFromClass([self class]) lowercaseString];
    if ([className rangeOfString:@"."].location!=NSNotFound) {
        className = [className componentsSeparatedByString:@"."].lastObject;
    }
    return className;
}

+ (NSString *)viewNameForAPI DEPRECATED_MSG_ATTRIBUTE("Use dataEndpointNameForAPI method instead") {
    return nil;
}

+ (NSString *)dataEndpointNameForAPI {
    return nil;
}

//This is Mantle method we have to prevent form invoking it form child classes of SCDataObject
+(NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *automaticMapping = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    NSDictionary *commonKeysMap = @{@"objectId":@"id"};
    NSDictionary *map = [automaticMapping mtl_dictionaryByAddingEntriesFromDictionary:commonKeysMap];
    return [map mtl_dictionaryByAddingEntriesFromDictionary:[self extendedPropertiesMapping]];
}

+ (NSDictionary *)extendedPropertiesMapping {
    return @{};
}

+ (NSDictionary *)cachedClassesOfProperties {
    static NSMutableDictionary *__cachePerClass = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __cachePerClass = [NSMutableDictionary dictionary];
    });
    
    NSString *className = NSStringFromClass(self);
    NSDictionary *__classesOfProperties = __cachePerClass[className];
    if (__classesOfProperties == nil) {
        __classesOfProperties = [self classesOfProperties];
        __cachePerClass[className] = __classesOfProperties;
    }
    
    return __classesOfProperties;
}

+ (Class)classForKey:(NSString *)key {
    NSString *className = [self cachedClassesOfProperties][key];
    Class aClass = NSClassFromString(className);
    return aClass;
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"owner_permissions"] ||
        [key isEqualToString:@"group_permissions"] ||
        [key isEqualToString:@"other_permissions"]) {
        return [SCConstants SCDataObjectPermissionsValueTransformer];
    }
    if ([key isEqualToString:@"created_at"] ||
        [key isEqualToString:@"updated_at"]) {
        return [SCConstants SCDataObjectDatesTransformer];
    }
    
    Class aClass = [self classForKey:key];
    if ([aClass isSubclassOfClass:[NSDate class]]) {
        return [SCConstants SCDataObjectDatesTransformer];
    }
    return nil;
}


+ (void)registerClass {
    [SCRegisterManager registerClass:[self class]];
}

+ (SCPlease *)please {
    if ([self dataEndpointNameForAPI] != nil) {
        return [self pleaseForDataEndpoint:[self dataEndpointNameForAPI]];
    }
    if([self viewNameForAPI] != nil) {
        return [self pleaseForView:[self viewNameForAPI]];
    }
    return [SCPlease pleaseInstanceForDataObjectWithClass:[self class]];
}

+ (SCPlease *)pleaseForView:(NSString *)viewName DEPRECATED_MSG_ATTRIBUTE("Use pleaseForDataEndpoint: method instead") {
    return [SCPleaseForView pleaseInstanceForDataObjectWithClass:[self class] forView:viewName];
}

+ (SCPlease *)pleaseForDataEndpoint:(NSString *)dataEndpointName {
    return [SCPleaseForDataEndpoint pleaseInstanceForDataObjectWithClass:[self class] fordataEndpoint:dataEndpointName];
}

+ (SCPlease *)pleaseFromSyncano:(Syncano *)syncano {
    if([self dataEndpointNameForAPI] != nil) {
        return [self pleaseForDataEndpoint:[self dataEndpointNameForAPI] fromSyncano:syncano];
    }
    if([self viewNameForAPI] != nil) {
        return [self pleaseForView:[self viewNameForAPI] fromSyncano:syncano];
    }
    return [SCPlease pleaseInstanceForDataObjectWithClass:[self class] forSyncano:syncano];
}

+ (SCPlease*)pleaseForView:(NSString *)viewName fromSyncano:(Syncano *)syncano DEPRECATED_MSG_ATTRIBUTE("Use pleaseForDataEndpoint:fromSyncano: method instead") {
    return [SCPleaseForView pleaseInstanceForDataObjectWithClass:[self class] forView:viewName forSyncano:syncano];
}

+ (SCPlease *)pleaseForDataEndpoint:(NSString *)dataEndpointName fromSyncano:(Syncano *)syncano {
    return [SCPleaseForDataEndpoint pleaseInstanceForDataObjectWithClass:[self class] fordataEndpoint:dataEndpointName forSyncano:syncano];
}

+ (SCPleaseForTemplate *)pleaseForTemplate:(NSString*)templateName {
    return [SCPleaseForTemplate pleaseInstanceForDataObjectWithClass:[self class] forTemplate:templateName];
}

+ (SCPleaseForTemplate *)pleaseForTemplate:(NSString*)templateName fromSyncano:(Syncano *)syncano {
    return [SCPleaseForTemplate pleaseInstanceForDataObjectWithClass:[self class] forTemplate:templateName forSyncano:syncano];
}


+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary {
    return [[SCParseManager sharedSCParseManager] parsedObjectOfClass:self fromJSONObject:dictionary];
}

- (id)init {
    self = [super init];
    if (self) {
        self.owner_permissions = SCDataObjectPermissionTypeNotSet;
        self.group_permissions = SCDataObjectPermissionTypeNotSet;
        self.other_permissions = SCDataObjectPermissionTypeNotSet;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[SCDataObject class]]) {
        return NO;
    }
    
    return [self isEqualToDataObject:(SCDataObject *)object];
}

- (BOOL)isEqualToDataObject:(SCDataObject *)object {
    return self.objectId == object.objectId;
}

- (NSString *)path {
    if (self.links[@"self"]) {
        return self.links[@"self"];
    }
    NSString *path;
    if (self.objectId) {
        path = [NSString stringWithFormat:@"classes/%@/objects/%@/",[[self class] classNameForAPI],self.objectId];
    } else {
        path = [NSString stringWithFormat:@"classes/%@/objects/",[[self class] classNameForAPI]];
    }
    return path;
}

- (void)fetchWithCompletion:(SCCompletionBlock)completion {
    [self fetchUsingAPIClient:[Syncano sharedAPIClient] completion:completion];
}

- (void)fetchFromSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self fetchUsingAPIClient:syncano.apiClient completion:completion];
}

- (void)fetchUsingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    [apiClient getDataObjectsFromClassName:[[self class] classNameForAPI] withId:self.objectId completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        [[SCParseManager sharedSCParseManager] fillObject:self withDataFromJSONObject:responseObject];
        if (completion) {
            completion(error);
        }
    }];
}

- (void)saveWithCompletionBlock:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)saveToSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)saveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    [self saveUsingAPIClient:apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)saveWithCompletionBlock:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self saveUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)saveToSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self saveUsingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)saveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self handleRelationsSaveUsingAPIClient:apiClient withCompletion:^(NSError *error) {
        if (error) {
            if (completion) {
                completion(error);
            }
        } else {
            
            NSMutableDictionary *params = [[[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:self error:&error] mutableCopy];
            if (error) {
                if (completion) {
                    completion(error);
                }
                if (revisionMismatchBlock) {
                    revisionMismatchBlock(NO,nil);
                }
            } else {
                if (self.objectId && self.revision && revisionMismatchBlock) {
                    params[kExpectedRevisionRequestParam] = self.revision;
                }
                [apiClient POSTWithPath:[self path] params:params  completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
                    if (error) {
                        if (completion) {
                            completion(error);
                        }
                        if (revisionMismatchBlock) {
                            [error checkIfMismatchOccuredWithCompletion:revisionMismatchBlock];
                        }
                        return;
                    }
                    [self updateObjectAfterSaveWithDataFromJSONObject:responseObject];
                    [self saveFilesUsingAPIClient:apiClient completion:^(NSError *error) {
                        if (completion) {
                            completion(error);
                        }
                        if (revisionMismatchBlock) {
                            revisionMismatchBlock(NO,nil);
                        }
                    }];
                    
                }];
            }
        }
    }];
}

- (void)updateObjectAfterSaveWithDataFromJSONObject:(id)responseObject {
    self.objectId = responseObject[@"id"];
    self.links = responseObject[@"links"];
    self.revision = responseObject[@"revision"];
    self.created_at = [[SCConstants SCDataObjectDatesTransformer] transformedValue:responseObject[@"created_at"]];
    self.updated_at = [[SCConstants SCDataObjectDatesTransformer] transformedValue:responseObject[@"updated_at"]];
}

- (void)saveFilesUsingAPIClient:(SCAPIClient *)apiClient completion:(SCCompletionBlock)completion {
    NSArray *filesProperties = [[self class] propertiesNamesOfFileClass];
    if (filesProperties.count > 0) {
        dispatch_group_t filesSaveGroup = dispatch_group_create();
        for (NSString *filePropertyName in filesProperties) {
            SCFile * file = (SCFile *)[self valueForKey:filePropertyName];
            if (file) {
                dispatch_group_enter(filesSaveGroup);
                [file saveAsPropertyWithName:filePropertyName ofDataObject:self withCompletion:^(NSError *error) {
                    dispatch_group_leave(filesSaveGroup);
                }];
            }
            
        }
        dispatch_group_notify(filesSaveGroup, dispatch_get_main_queue(), ^{
            if (completion) {
                completion(nil);
            }
        });
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

- (void)deleteWithCompletion:(SCCompletionBlock)completion {
    [self deleteUsingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)deleteFromSyncano:(Syncano *)syncano completion:(SCCompletionBlock)completion {
    [self deleteUsingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)deleteUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    [apiClient DELETEWithPath:[self path] params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)updateValue:(id)value forKey:(NSString *)key withCompletion:(SCCompletionBlock)completion {
    [self updateValue:value forKey:key usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}
- (void)updateValue:(id)value forKey:(NSString *)key inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self updateValue:value forKey:key usingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)updateValue:(id)value forKey:(NSString *)key withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock
{
    [self updateValue:value forKey:key usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}
- (void)updateValue:(id)value forKey:(NSString *)key inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock
{
    [self updateValue:value forKey:key usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)updateValue:(id)value forKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    [self updateValue:value forKey:key usingAPIClient:apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}


- (void)updateValue:(id)value forKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    NSError *validationError = nil;
    SCValidateAndSetValue(self, key, value, YES, &validationError);
    if (validationError) {
        if (completion) {
            completion(validationError);
        }
        return;
    }
    if ([[[self class] propertyKeys] containsObject:key]) {
        NSMutableDictionary *params = [@{key:value} mutableCopy];
        if (self.revision) {
            params[kExpectedRevisionRequestParam] = self.revision;
        }
        [apiClient PATCHWithPath:[self path] params:params completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
            if (completion) {
                completion(error);
                if (revisionMismatchBlock) {
                    if (error) {
                        [error checkIfMismatchOccuredWithCompletion:revisionMismatchBlock];
                    } else {
                        revisionMismatchBlock(NO,nil);
                    }
                }
            }
        }];
    } else {
        NSError *error; //TODO: create error
        completion(error);
    }
}


/**
 * In API it's possible to have attributes without any values. In this case, when parsing JSON
 * we will try to set a nil value for certain key. This works well in Obj-C but causes a crash
 * when Swift Class properties are not of optional type
 *
 * Implementing this method lets Swift app avoid crashing
 */
- (void)setNilValueForKey:(NSString *)key {
}

- (void)handleRelationsSaveUsingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    NSDictionary *relations = [SCRegisterManager relationsForClass:[self class]];
    if (relations.count > 0) {
        dispatch_group_t relationSaveGroup = dispatch_group_create();
        for (NSString *propertyName in relations.allKeys) {
            SCDataObject *relatedObject = [self valueForKey:propertyName];
            // no object here, go to saving next one
            if (relatedObject == nil) {
                continue;
            }
            if ([relatedObject isKindOfClass:[SCDataObject class]]) {
                if (!relatedObject.objectId) {
                    dispatch_group_enter(relationSaveGroup);
                    [relatedObject saveUsingAPIClient:apiClient withCompletion:^(NSError *error) {
                        dispatch_group_leave(relationSaveGroup);
                    }];
                }
            } else {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedString(@"Related object have to be sublass of SCDataObject", @""),
                                           NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"You cannot add reference of non SCDataObject subclass object",@""),
                                           };
                NSError *error = [NSError errorWithDomain:SCDataObjectErrorDomain  code:SCErrorCodeDataObjectWrongParentClass userInfo:userInfo];
                if (completion) {
                    completion(error);
                }
            }
        }
        dispatch_group_notify(relationSaveGroup, dispatch_get_main_queue(), ^{
            if (completion) {
                completion(nil);
            }
        });
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

#pragma mark - increment
- (void)incrementKey:(NSString*)key by:(NSNumber*)value withCompletion:(SCCompletionBlock)completion {
    [self incrementKeys:@{key:value} withCompletion:completion];
}

- (void)incrementKey:(NSString*)key by:(NSNumber*)value inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self incrementKeys:@{key:value} inSyncano:syncano withCompletion:completion];
}

- (void)incrementKey:(NSString*)key by:(NSNumber*)value withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self incrementKeys:@{key:value} withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)incrementKey:(NSString*)key by:(NSNumber*)value inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self incrementKeys:@{key:value} inSyncano:syncano withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys withCompletion:(SCCompletionBlock)completion {
    [self incrementKeys:keys usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self incrementKeys:keys usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:nil];
}

- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self incrementKeys:keys usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys inSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion revisionMismatchValidationBlock:(SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock {
    [self incrementKeys:keys usingAPIClient:syncano.apiClient withCompletion:completion revisionMismatchValidationBlock:revisionMismatchBlock];
}

@end
