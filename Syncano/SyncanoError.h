//
//  SyncanoError.h
//  Syncano
//
//  Created by Mateusz on 17.03.2015.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SyncanoErrorCode) {
  SyncanoErrorInvalidParameter = 0,
  SyncanoErrorResponseIsNotJSONDictionary
};

@interface SyncanoError : NSError

+ (id)errorWithCode:(SyncanoErrorCode)code;
+ (id)errorWithCode:(SyncanoErrorCode)code userInfo:(NSDictionary *)dictionary;

@end
