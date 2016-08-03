//
//  SCBatchResponseItem.h
//  syncano-ios
//
//  Created by Jan Lipmann on 03/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCBatchResponseItem : NSObject
@property (nonatomic) NSInteger code;
@property (nonatomic,retain) id content;

+ (SCBatchResponseItem *)itemWithJSONDictionary:(id)JSONDictionary;

@end
