//
//  NSString+JSONDictionary.m
//  syncano-ios
//
//  Created by Jan Lipmann on 18/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "NSString+JSONDictionary.h"

@implementation NSString (JSONDictionary)
- (NSDictionary *) sc_jsonDictionary:(NSError **)error {
    NSError *jsonError;
    NSData *objectData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    *error = jsonError;
    return JSON;
}
@end
