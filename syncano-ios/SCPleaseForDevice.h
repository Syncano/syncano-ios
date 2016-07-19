//
//  SCPleaseForDevice.h
//  syncano-ios
//
//  Created by Jan Lipmann on 18/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Syncano;

@interface SCPleaseForDevice : NSObject
+ (SCPleaseForDevice *)pleaseInstance;
+ (SCPleaseForDevice *)pleaseInstanceForSyncano:(Syncano *)syncano;
@end
