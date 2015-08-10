//
//  SCJSONHelper.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 23/07/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCJSONHelper.h"

@implementation SCJSONHelper
+ (id)JSONObjectFromFileWithName:(NSString *)filename {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:filename ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSError *jsonError;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    return JSONObject;
}
@end
