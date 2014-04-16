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

- (NSArray*)requiredParametersNames {
    return @[@"roleId", @"description"];
}

- (NSString *)methodName {
	return @"apikey.new";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_APIKeys_New responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * parameters = @{@"roleId" : @"role_id",
                                  @"description" : @"description"};
    
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

- (SyncanoParameters_APIKeys_GetOne *)initWithClientId:(NSString *)clientId {
    self = [super init];
    if (self) {
        self.clientId = clientId;
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
    NSDictionary * parameters = @{@"clientId" : @"client_id"};
    return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_APIKeys_UpdateDescription

- (SyncanoParameters_APIKeys_UpdateDescription*)initWithDescription:(NSString*)description {
    self = [super init];
    if (self) {
        self.description = description;
        [self validateParameters];
    }
    return self;
}

- (SyncanoParameters_APIKeys_UpdateDescription*)initWithDescription:(NSString*)description clientId:(NSString*)clientId{
    self = [super init];
    if (self) {
        self.description = description;
        self.clientId = clientId;
        [self validateParameters];
    }
    return self;
}

- (NSArray *)initalizeSelectorNamesArray {
    return @[@"initWithDescription:", @"initWithDescription:clientId:"];
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
    NSDictionary * parameters = @{@"clientId" : @"client_id",
                                  @"description" : @"description"};
    
    return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_APIKeys_Delete

- (SyncanoParameters_APIKeys_Delete*)initWithClientId:(NSString*)clientId {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        [self validateParameters];
    }
    return self;
}

- (SEL)initalizeSelector {
    return @selector(initWithClientId:);
}

- (NSArray *)requiredParametersNames {
    return @[@"clientId"];
}

- (NSString *)methodName {
	return @"apikey.delete";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse responseFromJSON:json];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * parameters = @{@"clientId" : @"client_id"};
    return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end
