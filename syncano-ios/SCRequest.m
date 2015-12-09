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
static NSString * const kRequestMethodUnknown = @"UNKNOWN";

@implementation SCRequest

- (NSDictionary *)dictionaryRepresentation {
    NSDictionary *dictRepresentation = @{@"path" : self.path,
                                         @"method" : [self methodToString],
                                         @"params" : [self params]};
    return dictRepresentation;
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
            return kRequestMethodUnknown;
            break;
    }
}

@end
