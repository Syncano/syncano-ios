//
//  SCAPIClient+SCFile.h
//  Pods
//
//  Created by Jan Lipmann on 30/06/15.
//
//

#import "SCAPIClient.h"
#import "AFNetworking/AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCAPIClient (SCFile)
/**
 *  Downloads file from provided URL
 *
 *  @param fileURL    NSURL of a file
 *  @param completion completion block
 *
 *  @return NSURLSessionDataTask
 */
+ (nullable NSURLSessionDataTask *)downloadFileFromURL:(NSURL *)fileURL withCompletion:(nullable SCAPIFileDownloadCompletionBlock)completion;

/**
 *  Downloads file with progres and saves it to local disk
 *
 *  @param fileURL    remote file URL
 *  @param storePath  local file store path
 *  @param progress   progress block
 *  @param completion completion block
 *
 *  @return NSURLSessionDownloadTask
 */
+ (nullable NSURLSessionDownloadTask *)downloadFileFromURL:(NSURL *)fileURL
                                    andSaveToPath:(NSURL *)storePath
                                     withProgress:(nullable SCFileDownloadProgressCompletionBlock)progress
                                   withCompletion:(nullable SCAPIFileDownloadCompletionBlock)completion;
@end
NS_ASSUME_NONNULL_END