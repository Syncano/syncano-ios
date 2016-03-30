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
+ (NSURLSessionDataTask *)downloadFileFromURL:(NSURL *)fileURL withCompletion:(SCAPIFileDownloadCompletionBlock)completion;
+ (NSURLSessionDownloadTask *)downloadFileFromURL:(NSURL *)fileURL
                                    andSaveToPath:(NSURL *)storePath
                                     withProgress:(SCFileDownloadProgressCompletionBlock)progress
                                   withCompletion:(SCAPIFileDownloadCompletionBlock)completion;
@end
