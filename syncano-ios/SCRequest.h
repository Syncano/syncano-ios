//
//  SCRequest.h
//  syncano-ios
//
//  Created by Jan Lipmann on 08/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SCRequestMethod) {
    SCRequestMethodUndefined,
    SCRequestMethodGET,
    SCRequestMethodPOST,
    SCRequestMethodPATCH,
    SCRequestMethodDELETE,
    SCRequestMethodPUT
};

@interface SCRequest : NSObject
@property (nonatomic,retain) NSString *identifier;
@property (nonatomic,retain) NSString *path;
@property (nonatomic) SCRequestMethod method;
@property (nonatomic,retain) NSDictionary *params;

- (instancetype)initWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params;

+ (SCRequest *)requestWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params;

- (NSDictionary *)dictionaryRepresentation;
@end
