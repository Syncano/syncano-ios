//
//  NSData+MimeType.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 12/08/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSData (MimeType)
- (NSString *)mimeTypeByGuessing;
@end
NS_ASSUME_NONNULL_END