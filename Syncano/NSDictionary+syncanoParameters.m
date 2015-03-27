//
//  NSDictionary+syncanoParameters.m
//  Syncano
//
//  Created by Mateusz on 24.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "NSDictionary+syncanoParameters.h"
#import "SyncanoObject.h"

@implementation NSMutableDictionary (syncanoParameters)

+ (NSDictionary *)syncanoParametersWithID:(NSNumber *)dbID {
  return [NSDictionary dictionaryWithObject:dbID forKey:kPropertyDBID];
}

- (NSNumber *)dbID {
  return self[kPropertyDBID];
}

@end
