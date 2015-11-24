//
//  SCLocalStoragePredicate.h
//  syncano-ios
//
//  Created by Jan Lipmann on 24/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPredicateProtocol.h"

@protocol SCLocalStoragePredicateProtocol <NSObject>
@required
- (NSPredicate *)nspredicateRepresentation;
@end
