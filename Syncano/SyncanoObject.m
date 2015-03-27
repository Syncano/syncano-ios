//
//  SyncanoObject.m
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SyncanoObject.h"

@implementation SyncanoObject

NSString *const kPropertyDBID = @"dbID";
NSString *const kPropertyCreatedAt = @"createdAt";
NSString *const kPropertyUpdatedAt = @"updatedAt";
NSString *const kPropertyRevision = @"revision";
NSString *const kPropertyLinks = @"links";
NSString *const kPropertyGroup = @"group";
NSString *const kPropertyGroupPermissions = @"groupPermissions";
NSString *const kPropertyOwner = @"owner";
NSString *const kPropertyOwnerPermissions = @"ownerPermissions";
NSString *const kPropertyOtherPermissions = @"otherPermissions";

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{kPropertyCreatedAt:@"created_at",
           kPropertyUpdatedAt:@"updated_at",
           kPropertyRevision:@"revision",
           kPropertyDBID:@"id",
           kPropertyLinks:@"links",
           kPropertyGroup:@"group",
           kPropertyGroupPermissions:@"group_permissions",
           kPropertyOwner:@"owner",
           kPropertyOwnerPermissions:@"owner_permissions",
           kPropertyOtherPermissions:@"other_permissions",
           };
}

@end
