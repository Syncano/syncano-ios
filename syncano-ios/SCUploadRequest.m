//
//  SCUploadRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 11/12/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCUploadRequest.h"

@implementation SCUploadRequest

- (instancetype)initWithPath:(NSString *)path propertName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    self = [super initWithPath:path method:SCRequestMethodPATCH params:nil callback:callback save:save];
    if (self) {
        self.propertyName = propertyName;
        self.fileData = fileData;
    }
    return self;
}

+ (SCUploadRequest *)uploadRequestWithPath:(NSString *)path propertName:(NSString *)propertyName fileData:(NSData *)fileData callback:(SCAPICompletionBlock)callback save:(BOOL)save {
    SCUploadRequest *request = [[SCUploadRequest alloc] initWithPath:path propertName:propertyName fileData:fileData callback:callback save:save];
    return request;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dict = [[super dictionaryRepresentation] mutableCopy];
    dict[@"propertyName"] = self.propertyName;
    dict[@"fileData"] = self.fileData;
    return [NSDictionary dictionaryWithDictionary:dict];
}
@end
