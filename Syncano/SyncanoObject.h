//
//  SyncanoObject.h
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncanoObjectProtocol.h"
#import <Mantle/Mantle.h>

extern NSString *const kPropertyDBID;
extern NSString *const kPropertyCreatedAt;
extern NSString *const kPropertyUpdatedAt;
extern NSString *const kPropertyRevision;
extern NSString *const kPropertyLinks;
extern NSString *const kPropertyGroup;
extern NSString *const kPropertyGroupPermissions;
extern NSString *const kPropertyOwner;
extern NSString *const kPropertyOwnerPermissions;
extern NSString *const kPropertyOtherPermissions;

@interface SyncanoObject : MTLModel <SyncanoObject> {
	NSDate *_createdAt;
	NSDate *_updatedAt;
	NSInteger _revision;
	NSInteger _dbID;
  NSDictionary *_links;
  NSString *_group;
  NSInteger _groupPermissions;
  NSString *_owner;
  NSInteger _ownerPermissions;
  NSInteger _otherPermissions;
}

@property (copy, readonly) NSDate *createdAt;
@property (copy, readonly) NSDate *updatedAt;
@property (assign, readonly) NSInteger revision;
@property (assign, readonly) NSInteger dbID;
@property (retain, readonly) NSDictionary *links;
@property (copy, readonly) NSString *group;
@property (assign, readonly) NSInteger groupPermissions;
@property (copy, readonly) NSString *owner;
@property (assign, readonly) NSInteger ownerPermissions;
@property (assign, readonly) NSInteger otherPermissions;

@end
