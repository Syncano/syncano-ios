//
//  Message.h
//  syncano-ios
//
//  Created by Jakub Machoń on 25.01.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCDataObject.h"

@interface Message : SCDataObject

@property (strong,nonatomic) NSString* text;
@property (strong,nonatomic) NSString* senderid;

@end
