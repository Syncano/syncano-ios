//
//  SyncanoParameters.h
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncanoParameters : NSObject <NSCopying, NSCoding>

@property (nonatomic, retain, readonly) NSDictionary *dictionary;

+ (instancetype)parametersWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
