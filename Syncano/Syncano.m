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

NSInteger const kSyncanoDefaultPageSize = 100;

@interface Syncano () {
	NSString *_apiKey;
}
@end


@implementation Syncano

@synthesize name=_name;

static Syncano *_sharedInstance = nil;

+ (NSDictionary *)settings {
	static NSDictionary *_settings = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_settings = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Syncano" ofType:@"plist"]]];
	});
	return _settings;
}

+ (instancetype)sharedInstanceWithAPIKey:(NSString *)apiKey name:(NSString *)name {
	static dispatch_once_t onceToken;
	
	__block NSString *defaultAPIKey = apiKey;
	__block NSString *defaultName = name;
	dispatch_once(&onceToken, ^{
		if (![defaultAPIKey length])
			defaultAPIKey = [Syncano settings][@"apiKey"];
		if (![defaultName length])
			defaultName = [Syncano settings][@"defaultName"];
		
		if ([defaultAPIKey length] && [defaultName length]) {
			_sharedInstance = [[Syncano alloc] initWithAPIKey:defaultAPIKey name:defaultName];
		}
	});
	
	return _sharedInstance;
}

+ (instancetype)sharedInstance {
	return [Syncano sharedInstanceWithAPIKey:[Syncano settings][@"apiKey"] name:[Syncano settings][@"defaultName"]];
}

+ (instancetype)setSharedInstanceName:(NSString *)name {
	Syncano *instance = [Syncano sharedInstance];
	if (!instance)
		return [Syncano sharedInstanceWithAPIKey:[Syncano settings][@"apiKey"] name:name];

	instance->_name = [name copy];
	return instance;
}

- (instancetype)initWithName:(NSString *)name {
	return [self initWithAPIKey:[Syncano settings][@"apiKey"] name:name];
}

- (instancetype)initWithAPIKey:(NSString *)apiKey name:(NSString *)name {
	if (![apiKey length] || ![name length])
		return nil;
	
	self = [super init];
	if (self) {
		_apiKey = [apiKey copy];
		_name = [name copy];
	}
	return self;
}

+ (instancetype)syncanoWithName:(NSString *)name {
	return [Syncano syncanoWithAPIKey:[Syncano settings][@"apiKey"] name:name];
}

+ (instancetype)syncanoWithAPIKey:(NSString *)apiKey name:(NSString *)name {
	return [[Syncano alloc] initWithAPIKey:apiKey name:name];
}

- (void)dealloc {
	_apiKey = nil;
	_name = nil;
}

- (NSURLSessionDataTask *)get:(Class)class params:(SyncanoParameters *)params success:(SyncanoObjectBlock)success failure:(SyncanoErrorBlock)failure {
	if (![class conformsToProtocol:@protocol(SyncanoObjectProtocol)]) {
		[NSException exceptionWithName:@"Syncano.InvalidParameterException" reason:[NSString stringWithFormat:@"%@ does not conform to protocol SyncanoObjectProtocol", NSStringFromClass(class)] userInfo:nil];
		return nil;
	}
	
	NSString *url = [NSString stringWithFormat:@"instances/%@/classes/%@/objects/%@", self.name, NSStringFromClass(class), params[@"dbID"]];
	return [[APIClient sharedClient] POST:url
														 parameters:params
																success:^(NSURLSessionDataTask *task, id responseObject) {
																	if (success) {
																		NSDictionary *json = responseObject;
																		if ([json isKindOfClass:[NSDictionary class]]) {
																			id<SyncanoObjectProtocol> object = [class alloc];
																			success(task, [object initWithJSON:json]);
																		}
																		else if (failure)
																			failure(task, [NSError errorWithDomain:@"Syncano" code:100 userInfo:nil]);
																	}
																}
																failure:^(NSURLSessionDataTask *task, NSError *error) {
																	if (failure)
																		failure(task, error);
																}];
}

- (NSURLSessionDataTask *)getArrayOf:(Class)class params:(SyncanoParameters *)params success:(SyncanoArrayBlock)success failure:(SyncanoErrorBlock)failure {
	return nil;
}

@end

