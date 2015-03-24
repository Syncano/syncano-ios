//
//  APIClient.m
//  Syncano
//
//  Created by Mateusz on 16.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

static NSString *const kSyncanoBaseURL = @"https://syncanotest1-env.elasticbeanstalk.com:443/";

+ (instancetype)sharedClient {
	static APIClient *_sharedClient = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kSyncanoBaseURL]];
		_sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    _sharedClient.securityPolicy.allowInvalidCertificates = YES; // TODO
		_sharedClient.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    _sharedClient->_jsonOutput = YES;
		_sharedClient.responseSerializer = (AFHTTPResponseSerializer <AFURLResponseSerialization> *)(_sharedClient.jsonOutput ? [AFJSONResponseSerializer serializer] : [AFJSONRequestSerializer serializer]);
	});
	return _sharedClient;
}

- (void)setJsonOutput:(BOOL)jsonOutput {
	_jsonOutput = jsonOutput;
	self.responseSerializer = jsonOutput ? [AFJSONResponseSerializer serializer] : [AFHTTPResponseSerializer serializer];
}

@end
