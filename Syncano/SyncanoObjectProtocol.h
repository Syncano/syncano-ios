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
@property (copy, readonly) NSString *sidekick;

@end
