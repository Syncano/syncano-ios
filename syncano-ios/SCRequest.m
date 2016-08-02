//
//  SCRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 08/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRequest.h"
#import "NSObject+SCParseHelper.h"

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
        self.method = [SCConstants requestMethodFromString:[dictionaryRepresentation[SCRequestMethodKey] sc_stringOrEmpty]];
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
    dict[SCRequestMethodKey] = [SCConstants requestMethodToString:self.method];
    if (self.params) {
        dict[SCRequestParamsKey] = self.params;
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)generateIdentifier {
    NSString *uuidString = [[NSProcessInfo processInfo] globallyUniqueString];
    return uuidString;
}

@end
