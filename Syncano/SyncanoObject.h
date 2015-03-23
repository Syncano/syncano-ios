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

@interface SyncanoObject : MTLModel <SyncanoObject> {
	NSDate *_createdAt;
	NSDate *_updatedAt;
	NSInteger _revision;
	NSInteger _dbID;
}

@property (copy, readonly) NSDate *createdAt;
@property (copy, readonly) NSDate *updatedAt;
@property (assign, readonly) NSInteger revision;
@property (assign, readonly) NSInteger dbID;

@end
