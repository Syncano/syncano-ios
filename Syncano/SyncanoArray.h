//
//  SyncanoArray.h
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncanoArray : NSMutableArray

@property (nonatomic, copy, readonly) NSString *prevURLString;
@property (nonatomic, copy, readonly) NSString *nextURLString;

@end
