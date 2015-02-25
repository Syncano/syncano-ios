//
//  SyncanoObject.h
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncanoObject : NSObject

@property (strong) NSDate *createdAt;
@property (strong) NSDate *updatedAt;
@property (assign) NSInteger revision;
@property (assign) NSInteger id;
@property (copy) NSString *sidekick;

@end
