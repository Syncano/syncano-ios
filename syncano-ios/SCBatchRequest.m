//
//  SCBatchRequest.m
//  syncano-ios
//
//  Created by Jan Lipmann on 01/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCBatchRequest.h"

@implementation SCBatchRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.identifier = [self generateIdentifier];
    }
    return self;
}

- (NSString *)generateIdentifier {
    NSString *uuidString = [[NSProcessInfo processInfo] globallyUniqueString];
    return uuidString;
}
@end
