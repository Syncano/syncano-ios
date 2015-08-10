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

@implementation SCFile

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
