//
//  SCFileManager.h
//  syncano-ios
//
//  Created by Jan Lipmann on 05/01/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCFileManager : NSObject
/**
 Returns <Application Home>/Library/Private Documents/Syncano
 for non-user generated data that shouldn't be deleted by iOS, such as "offline data".
 
 See https://developer.apple.com/library/ios/#qa/qa1699/_index.html
 */
+ (NSString *)syncanoDocumentsDirectoryPath;
+ (NSString *)syncanoDBFilePath;
@end

@class SCRequest;

@interface SCFileManager (Request)
+ (void)writeAsyncRequest:(SCRequest *)request queueIdentifier:(NSString *)queueIdentifier completionBlock:(nullable SCCompletionBlock)completionBlock;
+ (void)removeAsyncRequest:(SCRequest *)request queueIdentifier:(NSString *)queueIdentifier completionBlock:(nullable SCCompletionBlock)completionBlock;
+ (void)findAllRequestArchivesForQueueWithIdentifier:(NSString *)queueIdentifier completionBlock:(SCFindRequestsCompletionBlock)completionBlock;
@end

@interface SCFileManager (LocalStorage)
+ (void)cleanUpLocalStorage;
@end

NS_ASSUME_NONNULL_END