//
//  SCUploadRequest.h
//  syncano-ios
//
//  Created by Jan Lipmann on 11/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRequest.h"

@interface SCUploadRequest : SCRequest
@property (nonatomic,retain) NSString *propertyName;
@property (nonatomic,retain) NSData *fileData;

+ (SCUploadRequest *)uploadrRequestWithPath:(NSString *)path propertName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback;


@end
