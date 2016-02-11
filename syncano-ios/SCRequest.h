//
//  SCRequest.h
//  syncano-ios
//
//  Created by Jan Lipmann on 08/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

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
@property (nonatomic,strong) SCAPICompletionBlock callback;
@property (nonatomic) BOOL save;

- (instancetype)initWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save;

- (instancetype)initFromDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation;

+ (SCRequest *)requestWithPath:(NSString *)path method:(SCRequestMethod)method params:(NSDictionary *)params callback:(SCAPICompletionBlock)callback save:(BOOL)save;

- (NSDictionary *)dictionaryRepresentation;
@end
