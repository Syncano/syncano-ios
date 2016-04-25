//
//  SCUploadRequest.h
//  syncano-ios
//
//  Created by Jan Lipmann on 11/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRequest.h"

@interface SCUploadRequest : SCRequest
@property (nullable,nonatomic,retain) NSString *propertyName;
@property (nullable,nonatomic,retain) NSData *fileData;

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
+ (nullable SCUploadRequest *)uploadRequestWithPath:(nonnull NSString *)path propertName:(nonnull NSString *)propertyName fileData:(nonnull NSData *)fileData callback:(nullable SCAPICompletionBlock)callback save:(BOOL)save;


@end
