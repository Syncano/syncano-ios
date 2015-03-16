//
//  SyncanoObject.m
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SyncanoObject.h"
#import "NSObject+nullSafe.h"

@implementation SyncanoObject

+ (instancetype)objectWithJSON:(NSDictionary *)json {
	return [[[self class] alloc] initWithJSON:json];
}

- (id)initWithJSON:(NSDictionary *)json {
	self = [super init];
	if (self) {
		ASSIGN_IF_NOT_NIL(_createdAt, [json[@"createdAt"] nullSafe]);
		ASSIGN_IF_NOT_NIL(_updatedAt, [json[@"updatedAt"] nullSafe]);
		ASSIGN_IF_NOT_NIL(_revision, [[json[@"revision"] nullSafe] integerValue]);
		ASSIGN_IF_NOT_NIL(_dbID, [[json[@"dbID"] nullSafe] integerValue]);
		ASSIGN_IF_NOT_NIL(_sidekick, [json[@"sidekick"] nullSafe]);
	}
	return self;
}

@end
