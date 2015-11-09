//
//  SCParseManager+SCLocalStorage.h
//  syncano-ios
//
//  Created by Jan Lipmann on 05/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCParseManager.h"

@class SCDataObject;

@interface SCParseManager (SCLocalStorage)
- (NSDictionary *)JSONRepresentationOfDataObject:(SCDataObject *)dataObject error:(NSError *__autoreleasing *)error;
- (SCDataObject *)parsedObjectOfClassWithName:(NSString *)className fromJSON:(NSDictionary *)JSONDictionary error:(NSError *__autoreleasing *)error;
@end
