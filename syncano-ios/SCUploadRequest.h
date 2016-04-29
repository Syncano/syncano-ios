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

/**
 *  Creates upload request
 *
 *  @param path         URI of the request
 *  @param propertyName property (variable) name of a file
 *  @param fileData     NSData representation of a file
 *  @param callback     callback block
 *  @param save         boolean which determines if this request should be stored on disk
 *
 *  @return SCUploadRequest instance
 */
+ (SCUploadRequest *)uploadRequestWithPath:(NSString *)path propertName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback save:(BOOL)save;


@end
