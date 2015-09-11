//
//  SCFile.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 26/06/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCFile.h"
#import "NSObject+SCParseHelper.h"
#import "SCAPIClient+SCFile.h"
#import "SCDataObject.h"
#import "Syncano.h"

@interface SCFile ()
@property (nonatomic,retain) NSData *data;
@end

@implementation SCFile

+ (instancetype)fileWithaData:(NSData *)data {
    return [[SCFile alloc] initWithData:data];;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        self.data = data;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error {
    self = [super init];
    if (self) {
        if (dictionaryValue[@"value"]) {
            self.fileURL = [NSURL URLWithString:[dictionaryValue[@"value"] sc_stringOrEmpty]];
        }
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}


- (void)saveAsPropertyWithName:(NSString *)name ofDataObject:(SCDataObject *)dataObject withCompletion:(SCCompletionBlock)completion {
    [self saveAsPropertyWithName:name ofDataObject:dataObject usingAPIClient:[Syncano sharedAPIClient] withCompletion:completion];
}

- (void)saveAsPropertyWithName:(NSString *)name ofDataObject:(SCDataObject *)dataObject toSyncano:(Syncano *)syncano withCompletion:(SCCompletionBlock)completion {
    [self saveAsPropertyWithName:name ofDataObject:dataObject usingAPIClient:syncano.apiClient withCompletion:completion];
}

- (void)saveAsPropertyWithName:(NSString *)name ofDataObject:(SCDataObject *)dataObject usingAPIClient:(SCAPIClient *)apiClient withCompletion:(SCCompletionBlock)completion {
    [apiClient postUploadTaskWithPath:dataObject.path propertyName:name fileData:self.data completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if (completion) {
            completion(error);
        }
    }];
}

- (void)fetchInBackgroundWithCompletion:(SCFileFetchCompletionBlock)completion {
    [SCAPIClient downloadFileFromURL:self.fileURL withCompletion:^(id responseObject, NSError *error) {
        if (error) {
            if (completion) {
                completion(nil,error);
            }
        } else {
            NSData *data = [[NSData alloc] initWithData:responseObject];
            if (completion) {
                completion(data,nil);
            }
        }
    }];
}

@end
