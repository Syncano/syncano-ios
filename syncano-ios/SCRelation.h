//
//  SCRelation.h
//  syncano-ios
//
//  Created by Jan Lipmann on 09/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "SCConstants.h"

@class SCDataObject;

NS_ASSUME_NONNULL_BEGIN

@interface SCRelation : MTLModel

@property (nullable, nonatomic, copy) NSString *targetClassName;

- (void)addDataObject:(SCDataObject *)object;

- (void)removeDataObject:(SCDataObject *)object;
@end

NS_ASSUME_NONNULL_END
