//
//  SCParseManager+SCDevice.h
//  syncano-ios
//
//  Created by Jan Lipmann on 19/07/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCParseManager.h"

@class SCDevice;

@interface SCParseManager (SCDevice)
- (NSArray<SCDevice *> *)parsedDevicesFromJSONObject:(id)responseObject error:(NSError**)error;
@end
