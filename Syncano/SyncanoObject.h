//
//  SyncanoObject.h
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncanoObjectProtocol.h"

@interface SyncanoObject : NSObject <SyncanoObjectProtocol> {
	NSDate *_createdAt;
	NSDate *_updatedAt;
	NSInteger _revision;
	NSInteger _dbID;
	NSString *_sidekick;
}

@property (strong, readonly) NSDate *createdAt;
@property (strong, readonly) NSDate *updatedAt;
@property (assign, readonly) NSInteger revision;
@property (assign, readonly) NSInteger dbID;
@property (copy, readonly) NSString *sidekick;

@end
