//
//  SCPredicateProtocol.h
//  syncano-ios
//
//  Created by Jan Lipmann on 19/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCPredicateProtocol <NSObject>

@required
/**
 *  Returns string representation of a query for use with API
 *
 *  @return string query representation
 */
- (NSString *)queryRepresentation;

/**
 *  Returns raw preduicate
 *
 *  @return NSDictionary with raw predicate
 */
- (NSDictionary<NSString*,NSDictionary*> *)rawPredicate;
@optional

/**
 *  Returns NSPredicate for local storage search
 *
 *  @return NSPredicate representation of a query
 */
- (NSPredicate *)nspredicateRepresentation;
@end
