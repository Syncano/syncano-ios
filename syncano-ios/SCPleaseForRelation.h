//
//  SCPleaseForRelation.h
//  syncano-ios
//
//  Created by Jan Lipmann on 09/06/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPlease.h"

@class Syncano;

@interface SCPleaseForRelation : SCPlease
+ (SCPleaseForRelation *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass withRelationWithMembers:(NSArray *)members;
+ (SCPleaseForRelation *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forSyncano:(Syncano *)syncano withRelationWithMembers:(NSArray *)members;
@end
