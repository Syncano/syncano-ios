//
//  Syncano.m
//  Syncano
//
//  Created by Syncano Inc. on 23/12/13.
//  Copyright (c) 2013 Syncano Inc. All rights reserved.
//

#import "Syncano.h"

#import <AFNetworking/AFNetworking.h>

NSInteger const kSyncanoDefaultPageSize = 100;
NSString *const kSyncanoURL = @"https://syncanotest1-env.elasticbeanstalk.com:443/v1/";

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

- (id<SyncanoRequest>)get:(Class)class params:(SyncanoParameters *)params success:(SyncanoObjectBlock)success failure:(SyncanoErrorBlock)failure {
	return nil;
}

- (id<SyncanoRequest>)getArrayOf:(Class)class params:(SyncanoParameters *)params success:(SyncanoArrayBlock)success failure:(SyncanoErrorBlock)failure {
	return nil;
}

@end

