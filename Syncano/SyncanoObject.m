//
//  SyncanoObject.m
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SyncanoObject.h"

@implementation SyncanoObject

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"createdAt":@"created_at",
           @"updatedAt":@"updated_at",
           @"revision":@"revision",
           @"dbID":@"id"};
}

@end
