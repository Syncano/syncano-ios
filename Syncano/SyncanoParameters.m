//
//  SyncanoParameters.m
//  Syncano
//
//  Created by Mateusz on 25.02.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SyncanoParameters.h"

@interface SyncanoParameters ()
@property (nonatomic, retain) NSDictionary *dictionary;
@end

@implementation SyncanoParameters

NSString *const kPropertyDictionary = @"kPropertyDictionary";

+ (instancetype)parametersWithDictionary:(NSDictionary *)dict {
  return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
  self = [super init];
  if (self)
    self.dictionary = dict;
  return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeObject:self.dictionary forKey:kPropertyDictionary];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  NSDictionary *dict = [aDecoder decodeObjectForKey:kPropertyDictionary];
  if (![dict isKindOfClass:[NSDictionary class]])
    dict = nil;
  return [self initWithDictionary:dict];
}

@end
