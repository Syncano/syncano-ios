//
//  SCBatchResponseItem.h
//  syncano-ios
//
//  Created by Jan Lipmann on 03/08/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCBatchResponseItem : NSObject
@property (nonatomic,retain) NSNumber *code;
@property (nonatomic,retain) id content;
@property (nonatomic,retain) Class classToParse;

+ (SCBatchResponseItem *)itemWithJSONDictionary:(NSDictionary *)JSONDictionary classToParse:(Class)classToParse;

@end
