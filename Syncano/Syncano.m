
//
//  Syncano.m
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import "Syncano.h"
#import "APIClient.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle.h>
#import "SyncanoError.h"
#import "SyncanoException.h"
#import "SyncanoObject.h"

NSInteger const kSyncanoDefaultPageSize = 100;

NSString *const kAPIKey = @"apiKey";
NSString *const kDefaultName = @"defaultName";

NSString *const kSyncanoURLObjectsByDBID = @"v1/instances/%@/classes/%@/objects/%@/";
NSString *const kSyncanoURLObjects = @"v1/instances/%@/classes/%@/objects/";


@interface Syncano () {
}
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *name;
@end


@implementation Syncano

@synthesize name=_name;

static Syncano *_sharedInstance = nil;

+ (NSDictionary *)settings {
  static NSDictionary *_settings = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Syncano" ofType:@"plist"];
    if (filePath)
      _settings = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
  });
  return _settings;
}

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey name:(NSString *)name {
  static dispatch_once_t onceToken;
  
  __block NSString *defaultAPIKey = apiKey;
  __block NSString *defaultName = name;
  dispatch_once(&onceToken, ^{
    if (![defaultAPIKey length])
      defaultAPIKey = [Syncano settings][kAPIKey];
    if (![defaultName length])
      defaultName = [Syncano settings][kDefaultName];
    
    if ([defaultAPIKey length] && [defaultName length]) {
      _sharedInstance = [[self alloc] initWithAPIKey:defaultAPIKey name:defaultName];
    }
  });
  
  return _sharedInstance;
}

+ (instancetype)sharedInstance {
  return [Syncano sharedInstanceWithAPIKey:[Syncano settings][kAPIKey] name:[Syncano settings][kDefaultName]];
}

+ (instancetype)setSharedInstanceName:(NSString *)name {
  Syncano *instance = [Syncano sharedInstance];
  if (!instance)
    return [Syncano sharedInstanceWithAPIKey:[Syncano settings][kAPIKey] name:name];
  
  instance.name = name;
  return instance;
}

- (instancetype)initWithName:(NSString *)name {
  return [self initWithAPIKey:[Syncano settings][kAPIKey] name:name];
}

- (instancetype)initWithAPIKey:(NSString *)apiKey name:(NSString *)name {
  if (![apiKey length] || ![name length])
    return nil;
  
  self = [super init];
  if (self) {
    self.apiKey = apiKey;
    self.name = name;
  }
  return self;
}

+ (instancetype)syncanoWithName:(NSString *)name {
  return [Syncano syncanoWithAPIKey:[Syncano settings][kAPIKey] name:name];
}

+ (instancetype)syncanoWithAPIKey:(NSString *)apiKey name:(NSString *)name {
  return [[self alloc] initWithAPIKey:apiKey name:name];
}

- (void)dealloc {
}

- (APIClient *)apiClient {
  APIClient *client = [APIClient sharedClient];
  if (self.apiKey)
    [client.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.apiKey] forHTTPHeaderField:@"Authorization"];
  return client;
}

- (NSURLSessionDataTask *)get:(Class)class params:(NSDictionary *)params success:(SyncanoObjectBlock)success failure:(SyncanoErrorBlock)failure {
  if (![class conformsToProtocol:@protocol(SyncanoObject)]) {
    [[SyncanoException exceptionWithCode:SyncanoExceptionInvalidParameter reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", NSStringFromClass(class), NSStringFromProtocol(@protocol(SyncanoObject))]] raise];
    return nil;
  }
  
  NSString *url = [NSString stringWithFormat:kSyncanoURLObjectsByDBID, self.name, NSStringFromClass(class), params[kPropertyDBID]];
  NSMutableDictionary *dictionary = [params mutableCopy];
  [dictionary removeObjectForKey:kPropertyDBID];
  return [[self apiClient] GET:url
                    parameters:[dictionary allKeys].count ? dictionary : nil
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                         if (success) {
                           NSDictionary *json = responseObject;
                           if ([json isKindOfClass:[NSDictionary class]]) {
                             NSError *error = nil;
                             id<SyncanoObject> object = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:json error:&error];
                             if (error) {
                               if (failure)
                                 failure(task, error);
                             }
                             else
                               success(task, object);
                           }
                           else if (failure)
                             failure(task, [SyncanoError errorWithCode:SyncanoErrorResponseIsNotJSONDictionary]);
                         }
                       }
                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                         if (failure)
                           failure(task, error);
                       }];
}

- (NSURLSessionDataTask *)create:(Class)class params:(NSDictionary *)params success:(SyncanoObjectBlock)success failure:(SyncanoErrorBlock)failure {
  if (![class conformsToProtocol:@protocol(SyncanoObject)]) {
    [[SyncanoException exceptionWithCode:SyncanoExceptionInvalidParameter reason:[NSString stringWithFormat:@"%@ does not conform to protocol %@", NSStringFromClass(class), NSStringFromProtocol(@protocol(SyncanoObject))]] raise];
    return nil;
  }
  
  NSString *url = [NSString stringWithFormat:kSyncanoURLObjects, self.name, NSStringFromClass(class)];
  return [[self apiClient] POST:url
                     parameters:[params allKeys].count ? params : nil
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                          if (success) {
                            NSDictionary *json = responseObject;
                            if ([json isKindOfClass:[NSDictionary class]]) {
                              NSError *error = nil;
                              id<SyncanoObject> object = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:json error:&error];
                              if (error) {
                                if (failure)
                                  failure(task, error);
                              }
                              else
                                success(task, object);
                            }
                            else if (failure)
                              failure(task, [SyncanoError errorWithCode:SyncanoErrorResponseIsNotJSONDictionary]);
                          }
                        }
                        failure:^(NSURLSessionDataTask *task, NSError *error) {
                          if (failure)
                            failure(task, error);
                        }];
}

- (NSURLSessionDataTask *)getArrayOf:(Class)class params:(NSDictionary *)params success:(SyncanoArrayBlock)success failure:(SyncanoErrorBlock)failure {
  return nil;
}

@end

