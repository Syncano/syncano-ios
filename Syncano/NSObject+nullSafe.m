//
//  NSObject+nullSafe.m
//  LoaderSplitView
//
//  Created by Mateusz on 22.01.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "NSObject+nullSafe.h"

@implementation NSObject (nullSafe)

- (id)nullSafe {
  return [self isKindOfClass:[NSNull class]] ? nil : self;
}

@end
