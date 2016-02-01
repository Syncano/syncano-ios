//
//  SCAPIClient+SCFile.m
//  Pods
//
//  Created by Jan Lipmann on 30/06/15.
//
//

#import "SCAPIClient+SCFile.h"

@implementation SCAPIClient (SCFile)

+ (AFHTTPRequestOperation *)downloadFileFromURL:(NSURL *)fileURL withCompletion:(SCAPIFileDownloadCompletionBlock)completion {
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    AFHTTPRequestOperation *downloadRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [downloadRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (completion) {
            completion(responseObject,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil,error);
        }
    }];
    
    [downloadRequestOperation start];
    return downloadRequestOperation;
}

+ (NSURLSessionDownloadTask *)downloadFileFromURL:(NSURL *)fileURL
                                  andSaveToPath:(NSURL *)storePath
                                   withProgress:(SCFileDownloadProgressCompletionBlock)progress
                                 withCompletion:(SCAPIFileDownloadCompletionBlock)completion {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    
    [manager setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session,
                                                NSURLSessionDownloadTask * _Nonnull downloadTask,
                                                int64_t bytesWritten,
                                                int64_t totalBytesWritten,
                                                int64_t totalBytesExpectedToWrite) {
        if(progress) {
            progress(downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    }];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        return storePath;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if(completion) {
            completion(response,error);
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

@end
