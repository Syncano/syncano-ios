//
//  NSError+SCDataObject.h
//  syncano-ios
//
//  Created by Jan Lipmann on 07/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (SCDataObject)
+ (NSError*)errorForUnknownProperty:(NSString*)propertyName;
@end
