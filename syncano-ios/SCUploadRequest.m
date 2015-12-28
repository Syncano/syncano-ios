//
//  SCUploadRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 11/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCUploadRequest.h"

@implementation SCUploadRequest

- (instancetype)initWithPath:(NSString *)path propertName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback {
    self = [super initWithPath:path method:SCRequestMethodPOST params:nil callback:callback];
    if (self) {
        _propertyName = propertyName;
        _fileData = fileData;
    }
    return self;
}

+ (SCUploadRequest *)uploadrRequestWithPath:(NSString *)path propertName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback {
    SCUploadRequest *request = [[SCUploadRequest alloc] initWithPath:path propertName:propertyName fileData:fileData callback:callback];
    return request;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[super dictionaryRepresentation] mutableCopy];
    dict[@"propertyName"] = self.propertyName;
    dict[@"fileData"] = self.fileData;
    return [NSDictionary dictionaryWithDictionary:dict];
}
@end
