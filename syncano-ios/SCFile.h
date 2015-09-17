//
//  SCFile.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 26/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>
#import "SCConstants.h"

@class SCDataObject;

@interface SCFile : MTLModel<MTLJSONSerializing>

@property (nonatomic,copy) NSURL *fileURL;

+ (instancetype)fileWithaData:(NSData *)data;

- (void)saveAsPropertyWithName:(NSString *)name ofDataObject:(SCDataObject *)dataObject withCompletion:(SCCompletionBlock)completion;

- (void)fetchInBackgroundWithCompletion:(SCFileFetchCompletionBlock)completion;

@end
