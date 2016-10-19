//
//  SCSocket.h
//  syncano-ios
//
//  Created by Jan Lipmann on 14/10/2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, SocketRunMethod) {
    SocketRunMethodGET,
    SocketRunMethodPOST,
    SocketRunMethodPUT,
    SocketRunMethodPATCH,
    SocketRunMethodDELETE
};

@class Syncano;

@interface SCSocket : NSObject

- (void)runWithMethod:(SocketRunMethod)method endpointName:(NSString *)endpointName parameters:(NSDictionary *)params completion:(SCCustomResponseCompletionBlock)completion;

- (void)runWithMethod:(SocketRunMethod)method endpointName:(NSString *)endpointName parameters:(NSDictionary *)params usingSyncano:(Syncano *)syncano completion:(SCCustomResponseCompletionBlock)completion;

@end
