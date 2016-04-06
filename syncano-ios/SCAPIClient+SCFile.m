//
//  SCAPIClient+SCFile.m
//  Pods
//
//  Created by Jan Lipmann on 30/06/15.
//
//

#import "SCAPIClient+SCFile.h"

@implementation SCAPIClient (SCFile)

+ (NSURLSessionDataTask *)downloadFileFromURL:(NSURL *)fileURL withCompletion:(SCAPIFileDownloadCompletionBlock)completion {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (completion) {
            completion(data,error);
        }
    }];

    [dataTask resume];
    
    return dataTask;
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
