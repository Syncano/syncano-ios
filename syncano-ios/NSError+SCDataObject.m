//
//  NSError+SCDataObject.m
//  syncano-ios
//
//  Created by Jan Lipmann on 07/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "NSError+SCDataObject.h"
#import "SCConstants.h"

@implementation NSError (SCDataObject)
+ (NSError*)errorForUnknownProperty:(NSString*)propertyName {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedString(@"Property %@ does not exist", @""),propertyName],
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"You change value of non-existing property.",@""),
                               };
    return [NSError errorWithDomain:SCDataObjectErrorDomain  code:SCErrorCodeDataObjectNonExistingPropertyName userInfo:userInfo];
}
@end
