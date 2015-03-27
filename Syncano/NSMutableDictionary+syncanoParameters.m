//
//  NSMutableDictionary+syncanoParameters.m
//  Syncano
//
//  Created by Mateusz on 24.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "NSMutableDictionary+syncanoParameters.h"
#import "SyncanoObject.h"

@implementation NSMutableDictionary (syncanoParameters)

- (NSNumber *)dbID {
  return self[kPropertyDBID];
}

- (void)setDbID:(NSNumber *)dbID {
  if (!dbID)
    [self removeObjectForKey:kPropertyDBID];
  else
    [self setObject:dbID forKey:kPropertyDBID];
}

@end
