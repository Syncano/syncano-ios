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
  return @{@"createdAt":@"createdAt",
           @"updatedAt":@"updatedAt",
           @"revision":@"revision",
           @"dbID":@"id",
           @"sidekick":@"sidekick"};
}

@end
