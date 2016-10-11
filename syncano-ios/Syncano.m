//
//  syncano4_ios.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 26/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Syncano.h"
#import "SCAPIClient.h"
#import "SCParseManager.h"
#import "SCLocalStore.h"
#import "SCRegisterManager.h"
#import "SCUser+UserDefaults.h"
#import "SCPleaseForDataEndpoint.h"

static SCLocalStore *_localStore;

@interface Syncano ()

@end

@implementation Syncano

/**
 *  Initiates singleton instance of Syncano Class
 * 
 *  @param apiKey       API Key to authorize syncano
 *  @param instanceName name of the Syncano instance
 *
 *  @return Syncano singleton instance
 */
+ (Syncano *)instance {
    static dispatch_once_t pred;
    __strong static Syncano * instance= nil;
    dispatch_once( &pred, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (SCLocalStore *)localStore {
    return  _localStore;
}

+ (Syncano *)sharedInstanceWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    Syncano *syncano = [Syncano instance];
    [syncano setApiKey:apiKey instanceName:instanceName];
    syncano.apiClient = [SCAPIClient apiClientForSyncano:syncano];
    return syncano;
}

+ (Syncano *)sharedInstanceWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(SCCompletionBlock)completion {
    Syncano *syncano = [Syncano instance];
    [syncano setApiKey:apiKey instanceName:instanceName];
    syncano.apiClient = [SCAPIClient apiClientForSyncano:syncano];
    [syncano validateInstanceOnServerWithCompletion:completion];
    return syncano;
}

+ (NSString *)getApiKey {
    return [[Syncano instance] apiKey];
}

+ (NSString *)getInstanceName {
    return [[Syncano instance] instanceName];
}

+ (SCAPIClient *)sharedAPIClient {
    return [[Syncano instance] apiClient];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [SCRegisterManager autoregisterDataObjectSubclasses];
    }
    return self;
}

- (instancetype)initWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    self = [super init];
    if (self) {
        self.apiKey = apiKey;
        self.instanceName = instanceName;
        self.apiClient = [SCAPIClient apiClientForSyncano:self];
    }
    return self;
}

- (instancetype)initWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(SCCompletionBlock)completion {
    self = [self initWithApiKey:apiKey instanceName:instanceName];
    if (self) {
        [self validateInstanceOnServerWithCompletion:completion];
    }
    return self;
}

- (void)validateInstanceOnServerWithCompletion:(SCCompletionBlock)completion {
    [self.apiClient GETWithPath:@"" params:nil completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

+ (Syncano *)newSyncanoWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    Syncano *syncano = [[Syncano alloc] initWithApiKey:apiKey instanceName:instanceName];
    return syncano;
}

+ (Syncano *)newSyncanoWithApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName andValidateWithCompletion:(SCCompletionBlock)completion {
    Syncano *syncano = [[Syncano alloc] initWithApiKey:apiKey instanceName:instanceName andValidateWithCompletion:completion];
    return syncano;
}

- (void)setApiKey:(NSString *)apiKey instanceName:(NSString *)instanceName {
    self.apiKey = apiKey;
    self.instanceName = instanceName;
}

+(void)enableOfflineStorage {
    [self enableOfflineStorageWithCompletionBlock:nil];
}

+ (void)enableOfflineStorageWithCompletionBlock:(SCCompletionBlock)completionBlock {
    _localStore = [SCLocalStore new];
    [_localStore initializeDBWithCompletionBlock:completionBlock];
}

@end


@implementation Syncano (UserManagement)

+ (SCUser *)currenUser {
    return [SCUser currentUser];
}


+ (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(SCCompletionBlock)callback {
    [SCUser loginWithUsername:username password:password completion:callback];
}
- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(SCCompletionBlock)callback {
    [SCUser loginWithUsername:username password:password toSyncano:self completion:callback];
}

+ (void)loginWithUserKey:(NSString *)userKey callback:(SCCompletionBlock)callback {
    [SCUser saveUserKey:userKey];
    if (callback) {
        callback(nil);
    }
}
- (void)loginWithUserKey:(NSString *)userKey callback:(SCCompletionBlock)callback {
    [SCUser saveUserKey:userKey];
    if (callback) {
        callback(nil);
    }
}

+ (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion {
    [SCUser registerWithUsername:username password:password completion:completion];
}
- (void)registerWithUsername:(NSString *)username password:(NSString *)password completion:(SCCompletionBlock)completion {
    [SCUser registerWithUsername:username password:password inSyncano:self completion:completion];
}

+ (void)updatePasswordForCurrentUser:(NSString *)password withCompletion:(SCCompletionBlock)completion {
    [[self currenUser] updatePassword:password withCompletion:completion];
}

- (void)updatePasswordForCurrentUser:(NSString *)password withCompletion:(SCCompletionBlock)completion {
    [[SCUser currentUser] updatePassword:password inSyncno:self withCompletion:completion];
}

+ (void)updatePassword:(NSString *)password forUser:(SCUser *)user withCompletion:(SCCompletionBlock)completion {
    [user updatePassword:password withCompletion:completion];
    
}
- (void)updatePassword:(NSString *)password forUser:(SCUser *)user withCompletion:(SCCompletionBlock)completion {
    [user updatePassword:password inSyncno:self withCompletion:completion];
}

@end

@implementation Syncano (DataEndpoint)

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class callback:(SCDataObjectsCompletionBlock)callback {
    [[self class] getData:dataEndpointName forClass:class parameters:nil predicate:nil callback:callback];
}
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class callback:(SCDataObjectsCompletionBlock)callback {
    [self getData:dataEndpointName forClass:class parameters:nil predicate:nil callback:callback];
}

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters callback:(SCDataObjectsCompletionBlock)callback {
    [[self class] getData:dataEndpointName forClass:class parameters:parameters predicate:nil callback:callback];
}
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters callback:(SCDataObjectsCompletionBlock)callback {
    [self getData:dataEndpointName forClass:class parameters:parameters predicate:nil callback:callback];
}

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class predicate:(nullable id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback {
    [[self class] getData:dataEndpointName forClass:class parameters:nil predicate:predicate callback:callback];
}
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class predicate:(nullable id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback {
    [self getData:dataEndpointName forClass:class parameters:nil predicate:predicate callback:callback];
}

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(NSDictionary *)parameters predicate:(id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback {
    SCPlease *please = [SCPleaseForDataEndpoint pleaseInstanceForDataObjectWithClass:class fordataEndpoint:dataEndpointName];
    [please giveMeDataObjectsWithPredicate:predicate parameters:parameters completion:callback];
}
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(NSDictionary *)parameters predicate:(id<SCPredicateProtocol>)predicate callback:(SCDataObjectsCompletionBlock)callback {
    SCPlease *please = [SCPleaseForDataEndpoint pleaseInstanceForDataObjectWithClass:class fordataEndpoint:dataEndpointName forSyncano:self];
    [please giveMeDataObjectsWithPredicate:predicate parameters:parameters completion:callback];
}

#pragma mark -Template

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback {
    [[self class] getData:dataEndpointName forClass:class parameters:nil forTemplateWithName:templateName callback:callback];
}
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback {
    [self getData:dataEndpointName forClass:class parameters:nil forTemplateWithName:templateName callback:callback];
}

+ (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback {
    SCPleaseForTemplate *please = [SCPleaseForTemplate pleaseInstanceForDataObjectWithClass:class forDataEndpoint:dataEndpointName forTemplate:templateName];
    [please giveMeDataWithParameters:parameters completion:callback];
}
- (void)getData:(NSString *)dataEndpointName forClass:(Class)class parameters:(nullable NSDictionary *)parameters forTemplateWithName:(NSString *)templateName callback:(SCTemplateResponseCompletionBlock)callback {
    SCPleaseForTemplate *please = [SCPleaseForTemplate pleaseInstanceForDataObjectWithClass:class forDataEndpoint:dataEndpointName forTemplate:templateName forSyncano:self];
    [please giveMeDataWithParameters:parameters completion:callback];
}

@end
