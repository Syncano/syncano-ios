//
//  NSObject+SCParseHelper.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 12/05/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (SCParseHelper)
- (nullable NSString *)sc_stringOrEmpty;
- (nullable NSNumber *)sc_numberOrNil;
- (nullable NSArray *)sc_arrayOrNil;
- (nullable NSDictionary *)sc_dictionaryOrNil;
- (nullable NSDate *)sc_dateOrNil;
- (nullable id)sc_objectOrNil;
@end
NS_ASSUME_NONNULL_END