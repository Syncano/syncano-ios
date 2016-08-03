//
//  NSError+SCBatch.h
//  syncano-ios
//
//  Created by Jan Lipmann on 03/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (SCBatch)
+ (NSError*)maxRequestExceededErrorForMaxRequestNumber:(NSInteger)max;
@end
