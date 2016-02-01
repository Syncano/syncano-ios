//
//  Book.h
//  SyncanoTestApp
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Likomp. All rights reserved.
//

#import "SCDataObject.h"
#import "SCFile.h"
#import "Author.h"

@interface Book : SCDataObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSNumber *numOfPages;
@property (nonatomic,copy) Author *author;
@property (nonatomic,strong) SCFile *content;
@end
