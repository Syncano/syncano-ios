//
//  SyncanoParameters_APIKeys.m
//  Syncano
//
//  Created by Syncano Inc. on 12/03/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_APIKeys.h"
#import "SyncanoParameters_Private.h"
#import "SyncanoResponse_APIKeys.h"

NSString *const kSyncanoParametersAPIKeyTypeBackend = @"backend";
NSString *const kSyncanoParametersAPIKeyTypeUser = @"user";

@implementation SyncanoParameters_APIKeys_StartSession
- (NSString *)methodName {
	return @"apikey.start_session";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_APIKeys_StartSession responseFromJSON:json];
}

@end

@implementation SyncanoParameters_APIKeys_New

- (SyncanoParameters_APIKeys_New *)initWithRoleId:(NSString *)roleId description:(NSString *)description {
	self = [super init];
	if (self) {
		self.roleId = roleId;
		self.description = description;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithRoleId:description:);
}

- (NSArray *)requiredParametersNames {
	return @[@"roleId", @"description"];
}

- (NSString *)methodName {
	return @"apikey.new";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_APIKeys_New responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"roleId" : @"role_id",
		                          @"description" : @"description" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_APIKeys_Get
- (NSString *)methodName {
	return @"apikey.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_APIKeys_Get responseFromJSON:json];
}

@end

@implementation SyncanoParameters_APIKeys_GetOne

- (SyncanoParameters_APIKeys_GetOne *)initWithApiClientId:(NSString *)apiClientId {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
	}
	return self;
}

- (NSString *)methodName {
	return @"apikey.get_one";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_APIKeys_GetOne responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_APIKeys_UpdateDescription

- (SyncanoParameters_APIKeys_UpdateDescription *)initWithDescription:(NSString *)description {
	self = [super init];
	if (self) {
		self.description = description;
		[self validateParameters];
	}
	return self;
}

- (SyncanoParameters_APIKeys_UpdateDescription *)initWithDescription:(NSString *)description apiClientId:(NSString *)apiClientId {
	self = [super init];
	if (self) {
		self.description = description;
		self.apiClientId = apiClientId;
		[self validateParameters];
	}
	return self;
}

- (NSArray *)initializeSelectorNamesArray {
	return @[@"initWithDescription:", @"initWithDescription:apiClientId:"];
}

- (NSArray *)requiredParametersNames {
	return @[@"description"];
}

- (NSString *)methodName {
	return @"apikey.update_description";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_APIKeys_UpdateDescription responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"description" : @"description" };

	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_APIKeys_Authorize

- (SyncanoParameters_APIKeys_Authorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithApiClientId:permission:);
}

- (NSArray *)requiredParametersNames {
	return @[@"apiClientId", @"permission"];
}

- (NSString *)methodName {
	return @"apikey.authorize";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"permission" : @"permission" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_APIKeys_Deauthorize

- (SyncanoParameters_APIKeys_Deauthorize *)initWithApiClientId:(NSString *)apiClientId permission:(NSString *)permission {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		self.permission = permission;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithApiClientId:permission:);
}

- (NSArray *)requiredParametersNames {
	return @[@"apiClientId", @"permission"];
}

- (NSString *)methodName {
	return @"apikey.deauthorize";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id",
		                          @"permission" : @"permission" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_APIKeys_Delete

- (SyncanoParameters_APIKeys_Delete *)initWithApiClientId:(NSString *)apiClientId {
	self = [super init];
	if (self) {
		self.apiClientId = apiClientId;
		[self validateParameters];
	}
	return self;
}

- (SEL)initalizeSelector {
	return @selector(initWithApiClientId:);
}

- (NSArray *)requiredParametersNames {
	return @[@"apiClientId"];
}

- (NSString *)methodName {
	return @"apikey.delete";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	NSDictionary *parameters = @{ @"apiClientId" : @"api_client_id" };
	return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
