//
//  SyncanoObjectProtocol.h
//  Syncano
//
//  Created by Mateusz on 16.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncanoObjectProtocol <NSObject>

@required
+ (instancetype)objectWithJSON:(NSDictionary *)json;
- (id)initWithJSON:(NSDictionary *)json;

- (NSDate *)createdAt;
- (NSDate *)updatedAt;
- (NSInteger)revision;
- (NSInteger)dbID;
- (NSString *)sidekick;

@end
