//
//  SyncanoException.m
//  Syncano
//
//  Created by Mateusz on 17.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SyncanoException.h"

@implementation SyncanoException

NSString *const kSyncanoExceptionInvalidParameter = @"Syncano.InvalidParameterException";

+ (instancetype)exceptionWithCode:(SyncanoExceptionCode)code {
  NSString *reason = nil;
  
  switch (code) {
    default:
      break;
  }
  
  return [[self class] exceptionWithCode:code reason:reason];
}

+ (instancetype)exceptionWithCode:(SyncanoExceptionCode)code reason:(NSString *)reason {
  NSString *name = nil;
  NSDictionary *userInfo = nil;
  
  switch (code) {
    case SyncanoExceptionInvalidParameter:
      name = kSyncanoExceptionInvalidParameter;
      break;
      
    default:
      break;
  }
  
  return [[self alloc] initWithName:name reason:reason userInfo:userInfo];
}

@end
