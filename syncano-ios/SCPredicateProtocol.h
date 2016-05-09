//
//  SCPredicateProtocol.h
//  syncano-ios
//
//  Created by Jan Lipmann on 19/09/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SCPredicateProtocol <NSObject>

@required
/**
 *  Returns string representation of a query for use with API
 *
 *  @return string query representation
 */
- (nullable NSString *)queryRepresentation;

/**
 *  Returns raw preduicate
 *
 *  @return NSDictionary with raw predicate
 */
- (nullable NSDictionary<NSString*,NSDictionary*> *)rawPredicate;
@optional

/**
 *  Returns NSPredicate for local storage search
 *
 *  @return NSPredicate representation of a query
 */
- (nullable NSPredicate *)nspredicateRepresentation;
@end
NS_ASSUME_NONNULL_END