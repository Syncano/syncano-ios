//
//  SCAPIClient+SCFile.h
//  Pods
//
//  Created by Jan Lipmann on 30/06/15.
//
//

#import "SCAPIClient.h"
#import "AFNetworking/AFNetworking.h"

@interface SCAPIClient (SCFile)
/**
 *  Downloads file from provided URL
 *
 *  @param fileURL    NSURL of a file
 *  @param completion completion block
 *
 *  @return AFHTTPRequestOperation
 */
+ (NSURLSessionDataTask *)downloadFileFromURL:(NSURL *)fileURL withCompletion:(SCAPIFileDownloadCompletionBlock)completion;

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
+ (NSURLSessionDownloadTask *)downloadFileFromURL:(NSURL *)fileURL
                                    andSaveToPath:(NSURL *)storePath
                                     withProgress:(SCFileDownloadProgressCompletionBlock)progress
                                   withCompletion:(SCAPIFileDownloadCompletionBlock)completion;
@end
