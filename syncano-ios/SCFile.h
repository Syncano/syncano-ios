//
//  SCFile.h
//  syncano-ios
//
//  Created by Jan Lipmann on 26/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "SCConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class SCDataObject;

@interface SCFile : MTLModel<MTLJSONSerializing>

/**
 *  Remote URL of a file
 */
@property (nullable,nonatomic,copy) NSURL *fileURL;

/**
 *  Local path to the file
 */
@property (nullable,nonatomic,copy) NSURL *storeURL;

/**
 *  NSData representation of a file
 */
@property (nullable,nonatomic,readonly) NSData *data;

/**
 *  After set this property to YES fetched data will be stored and can be accessed via 'data' property
 */
@property (nonatomic) BOOL storeDataAfterFetch;

/**
 * Informs if file will be sent to Syncano when saving object containig it. Read-only
 */
@property (nonatomic, readonly) BOOL needsToBeUploaded;

/**
 *  SCFile initializer
 *
 *  @param data NSData representation of a file
 *
 *  @return SCFile instance
 */
+ (instancetype)fileWithaData:(NSData *)data;

/**
 *  Attempts to save file to server, 'data' proeprty cannot be nil
 *
 *  @param name       name of the data object param that is associated with this file
 *  @param dataObject data object which this file is part of
 *  @param completion completion block
 */
- (void)saveAsPropertyWithName:(NSString *)name ofDataObject:(SCDataObject *)dataObject withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Attempts to fetch file from server.
 *
 *  @param completion completion block
 */
- (void)fetchInBackgroundWithCompletion:(SCFileFetchCompletionBlock)completion;

/**
 *  Attempts to fetch file from server and store it under given location.
 *
 *  @param storePath  Path on disk where file should be stored. You can pass nil here then file will be stored under temporary location.
 *  @param progress   Progress information block
 *  @param completion Completion block
 *
 *  @return Download task. You can use it f.e. to suspend or resume download.
 */
- (NSURLSessionDownloadTask *)fetchToFileInBackground:(NSURL* )storePath withProgress:(nullable SCFileDownloadProgressCompletionBlock)progress completion:(nullable SCFileFetchToDiskCompletionBlock)completion;

/**
 *  Attempts to fetch file from server and store it under self.storeURL location.
 *
 *  @param progress   Progress information block
 *  @param completion Completion block
 *
 *  @return Download task. You can use it f.e. to suspend or resume download.
 */
- (NSURLSessionDownloadTask *)fetchToFileInBackgroundWithProgress:(nullable SCFileDownloadProgressCompletionBlock)progress completion:(nullable SCFileFetchToDiskCompletionBlock)completion;

@end
NS_ASSUME_NONNULL_END