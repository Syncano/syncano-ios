//
//  SCPleaseForTemplate.h
//  syncano-ios
//
//  Created by Jan Lipmann on 10/05/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPlease.h"

@class Syncano;

@interface SCPleaseForTemplate : SCPlease
/**
 *  Initializes new empty SCPlease object for provided SCDataObject class
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param viewName Name of Data Object View
 *
 *  @return SCPlease object
 */
- (instancetype)initWithDataObjectClass:(Class)dataObjectClass forTemplate:(NSString*)templateName;

/**
 *  Creates a new SCPlease object for provided class for singleton Syncano instance.
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param viewName Name of Data Object View
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forTemplate:(NSString*)templateName;

/**
 *  Creates a new SCPlease object for provided class for provided Syncano instance
 *
 *  @param dataObjectClass SCDataObject scope class
 *  @param viewName Name of Data Object View
 *  @param syncano         Syncano instance
 *
 *  @return SCPlease object
 */
+ (SCPlease *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forTemplate:(NSString*)templateName forSyncano:(Syncano *)syncano;


- (void)giveMeDataWithParameters:(NSDictionary*)parameters completion:(SCTemplateResponseCompletionBlock)completion;
@end
