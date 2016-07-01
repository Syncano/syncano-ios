//
//  SCAPIClient+SCDataObject.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCAPIClient+SCDataObject.h"

@implementation SCAPIClient (SCDataObject)
- (void)getDataObjectsFromClassName:(NSString *)className params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"classes/%@/objects/",className];
    [self GETWithPath:path params:params completion:completion];
}

- (void)getDataObjectsFromClassName:(NSString *)className withId:(NSNumber *)identifier completion:(SCAPICompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"classes/%@/objects/%@/",className,identifier];
    [self GETWithPath:path params:nil completion:completion];
}

- (void)getDataObjectsFromViewName:(NSString *)viewName params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion DEPRECATED_MSG_ATTRIBUTE("Use getDataObjectsFromdataEndpointWithName:params:completion: method instead") {
    NSString *path = [NSString stringWithFormat:@"api/objects/%@/get/",viewName];
    [self GETWithPath:path params:params completion:completion];
}

- (void)getDataObjectsFromdataEndpointWithName:(NSString *)dataEndpointName params:(NSDictionary *)params completion:(SCAPICompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"endpoints/data/%@/get/",dataEndpointName];
    [self GETWithPath:path params:params completion:completion];
}

@end
