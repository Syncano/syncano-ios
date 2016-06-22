//
//  NSString+PathManipulations.m
//  syncano-ios
//
//  Created by Jan Lipmann on 22/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "NSString+PathManipulations.h"

@implementation NSString (PathManipulations)
- (NSString *)pathStringByAppendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }
    return [NSString stringWithFormat:@"%@%@%@", self,
            [self rangeOfString:@"?"].length > 0 ? @"&" : @"?", queryString];
}
@end
