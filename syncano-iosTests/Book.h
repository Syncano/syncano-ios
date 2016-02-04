//
//  Book.h
//  SyncanoTestApp
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Likomp. All rights reserved.
//

#import "SCDataObject.h"
#import "Author.h"
#import "SCFile.h"

@interface Book : SCDataObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSNumber *numOfPages;
@property (nonatomic, copy) SCFile *cover;
@property (nonatomic, copy) SCFile *content;
@property (nonatomic,copy) Author *author;

@property (nonatomic,copy) NSNumber *lovers;
@property (nonatomic,copy) NSNumber *readers;

@end
