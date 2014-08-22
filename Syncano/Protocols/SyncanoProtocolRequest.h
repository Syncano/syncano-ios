//
//  SyncanoProtocolRequest.h
//  Syncano
//
//  Created by Mariusz Wisniewski on 22/08/14.
//  Copyright (c) 2014 Mindpower. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SyncanoRequest <NSObject>

@required

- (BOOL)isCancelled;
- (void)cancel;

- (BOOL)isExecuting;
- (BOOL)isFinished;

@end
