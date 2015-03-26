//
//  NSDictionary+syncanoParameters.h
//  Syncano
//
//  Created by Mateusz on 24.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (syncanoParameters)

@property (nonatomic, copy, readonly) NSNumber *dbID;

+ (NSDictionary *)syncanoParametersWithID:(NSNumber *)dbID;

@end
