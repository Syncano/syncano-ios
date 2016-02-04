//
//  Device.h
//  syncano-ios
//
//  Created by Jakub Machoń on 26.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject.h"

@interface Device : SCDataObject

@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSString* manufacturer;

@end
