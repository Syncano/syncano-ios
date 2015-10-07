//
//  SCSQLiteDatabase.h
//  syncano-ios
//
//  Created by Jan Lipmann on 06/10/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCSQLiteDatabase : NSObject
- (instancetype)initWithPath:(NSString *)path;

- (void)open;
- (void)close;
@end
