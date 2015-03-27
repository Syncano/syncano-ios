//
//  SyncanoException.h
//  Syncano
//
//  Created by Mateusz on 17.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kSyncanoExceptionInvalidParameter;

typedef NS_ENUM(NSInteger, SyncanoExceptionCode) {
  SyncanoExceptionInvalidParameter = 0
};

@interface SyncanoException : NSException

+ (instancetype)exceptionWithCode:(SyncanoExceptionCode)code;
+ (instancetype)exceptionWithCode:(SyncanoExceptionCode)code reason:(NSString *)reason;

@end
