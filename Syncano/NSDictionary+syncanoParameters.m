//
//  NSDictionary+syncanoParameters.m
//  Syncano
//
//  Created by Mateusz on 24.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "NSDictionary+syncanoParameters.h"
#import "SyncanoObject.h"

@implementation NSDictionary (syncanoParameters)

+ (NSDictionary *)syncanoParametersWithID:(NSString *)dbID {
  return [NSDictionary dictionaryWithObject:dbID forKey:kPropertyDBID];
}

@end
