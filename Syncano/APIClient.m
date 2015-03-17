//
//  APIClient.m
//  Syncano
//
//  Created by Mateusz on 16.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

+ (instancetype)sharedClient {
	static APIClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		NSDictionary *config = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]]];
		_sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:config[@"BaseURL"]]];
		_sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
		_sharedClient.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
		_sharedClient.responseSerializer = _sharedClient.jsonOutput ? [AFJSONResponseSerializer serializer] : [AFHTTPResponseSerializer serializer];
	});
	return _sharedClient;
}

- (void)setJsonOutput:(BOOL)jsonOutput {
	_jsonOutput = jsonOutput;
	self.responseSerializer = jsonOutput ? [AFJSONResponseSerializer serializer] : [AFHTTPResponseSerializer serializer];
}

@end
