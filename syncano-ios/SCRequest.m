//
//  SCRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 08/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRequest.h"
#import "NSObject+SCParseHelper.h"

static NSString * const kRequestMethodGET = @"GET";
static NSString * const kRequestMethodPOST = @"POST";
static NSString * const kRequestMethodPATCH = @"PATCH";
static NSString * const kRequestMethodDELETE = @"DELETE";
static NSString * const kRequestMethodPUT = @"PUT";
static NSString * const kRequestMethodUndefined = @"UNDEFINED";

static NSString * const SCRequestPathKey = @"path";
static NSString * const SCRequestMethodKey = @"method";
static NSString * const SCRequestParamsKey = @"params";
static NSString * const SCRequestIdentifierKey = @"identifier";

@implementation SCRequest

- (instancetype)initWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    self = [super init];
    if (self) {
        self.path = path;
        self.method = method;
        self.params = params;
        self.identifier = [self generateIdentifier];
        self.callback = callback;
        self.save = save;
    }
    return self;
}

- (instancetype)initFromDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation {
    self = [super init];
    if (self) {
        self.identifier = [dictionaryRepresentation[SCRequestIdentifierKey] sc_stringOrEmpty];
        self.path = [dictionaryRepresentation[SCRequestPathKey] sc_stringOrEmpty];
        self.method = [self methodFromString:[dictionaryRepresentation[SCRequestMethodKey] sc_stringOrEmpty]];
        self.params = [dictionaryRepresentation[SCRequestParamsKey] sc_dictionaryOrNil];
    }
    return self;
}

+ (SCRequest *)requestWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    return [[self alloc] initWithPath:path method:method params:params callback:callback save:save];
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[SCRequestIdentifierKey] = self.identifier;
    dict[SCRequestPathKey] = self.path;
    dict[SCRequestMethodKey] = [self methodToString];
    if (self.params) {
        dict[SCRequestParamsKey] = self.params;
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
