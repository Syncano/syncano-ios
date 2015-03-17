//
//  SyncanoError.m
//  Syncano
//
//  Created by Mateusz on 17.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SyncanoError.h"

@implementation SyncanoError

+ (id)errorWithCode:(SyncanoErrorCode)code {
  return [[self class] errorWithCode:code userInfo:nil];
}

+ (id)errorWithCode:(SyncanoErrorCode)code userInfo:(NSDictionary *)dictionary {
  return [[self class] errorWithDomain:@"Syncano" code:code userInfo:dictionary];
}

@end
