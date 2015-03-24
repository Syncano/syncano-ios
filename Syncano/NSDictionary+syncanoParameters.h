//
//  NSDictionary+syncanoParameters.h
//  Syncano
//
//  Created by Mateusz on 24.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (syncanoParameters)

+ (NSDictionary *)syncanoParametersWithID:(NSString *)dbID;

@end
