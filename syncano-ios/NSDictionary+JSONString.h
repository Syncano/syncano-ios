//
//  NSDictionary+JSONString.h
//  syncano-ios
//
//  Created by Jan Lipmann on 18/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary (JSONString)
-(NSString*) sc_jsonStringWithPrettyPrint:(BOOL) prettyPrint error:( NSError **)error;
@end
NS_ASSUME_NONNULL_END