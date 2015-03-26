//
//  SyncanoObjectProtocol.h
//  Syncano
//
//  Created by Mateusz on 16.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@protocol SyncanoObject <MTLJSONSerializing>

@required

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
