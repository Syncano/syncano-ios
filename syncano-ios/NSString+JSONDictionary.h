//
//  NSString+JSONDictionary.h
//  syncano-ios
//
//  Created by Jan Lipmann on 18/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSONDictionary)
- (nullable NSDictionary *) sc_jsonDictionary:(NSError *  __autoreleasing _Nullable * _Nullable)error;
@end
