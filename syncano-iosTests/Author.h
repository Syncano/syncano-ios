//
//  Author.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 03/04/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//
#import "SCDataObject.h"

@interface Author : SCDataObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *surname;
@property (nonatomic,copy) NSNumber *yearofbirth;
@property (nonatomic,copy) NSNumber *yearofdeath;
@end
