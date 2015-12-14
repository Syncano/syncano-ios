//
//  SCRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 08/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRequest.h"

static NSString * const kRequestMethodGET = @"GET";
static NSString * const kRequestMethodPOST = @"POST";
static NSString * const kRequestMethodPATCH = @"PATCH";
static NSString * const kRequestMethodDELETE = @"DELETE";
static NSString * const kRequestMethodPUT = @"PUT";
static NSString * const kRequestMethodUndefined = @"UNDEFINED";

@implementation SCRequest

- (instancetype)initWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        _path = path;
        _method = method;
        _params = params;
        _identifier = [self generateIdentifier];
    }
    return self;
}

+ (SCRequest *)requestWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params {
    return [[self alloc] initWithPath:path method:method params:params];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"path"] = self.path;
    dict[@"method"] = [self methodToString];
    if (self.params) {
        dict[@"params"] = self.params;
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (SCRequestMethod)methodFromString:(NSString *)methodString {
    if ([methodString isEqualToString:kRequestMethodGET]) {
        return SCRequestMethodGET;
    }
    if ([methodString isEqualToString:kRequestMethodPOST]) {
        return SCRequestMethodPOST;
    }
    if ([methodString isEqualToString:kRequestMethodPATCH]) {
        return SCRequestMethodPATCH;
    }
    if ([methodString isEqualToString:kRequestMethodDELETE]) {
        return SCRequestMethodDELETE;
    }
    if ([methodString isEqualToString:kRequestMethodPUT]) {
        return SCRequestMethodPUT;
    }
    return SCRequestMethodUndefined;
}

- (NSString *)methodToString {
    switch (self.method) {
        case SCRequestMethodGET:
            return kRequestMethodGET;
            break;
        case SCRequestMethodPOST:
            return kRequestMethodPOST;
            break;
        case SCRequestMethodPATCH:
            return kRequestMethodPATCH;
            break;
        case SCRequestMethodDELETE:
            return kRequestMethodDELETE;
            break;
        case SCRequestMethodPUT:
            return kRequestMethodPUT;
            break;
        default:
            return kRequestMethodUndefined;
            break;
    }
}

- (NSString *)generateIdentifier {
    NSString *uuidString = [[NSProcessInfo processInfo] globallyUniqueString];
    return uuidString;
}

@end
