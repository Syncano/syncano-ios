//
//  Book.m
//  SyncanoTestApp
//
//  Created by Jan Lipmann on 02/04/15.
//  Copyright (c) 2015 Likomp. All rights reserved.
//

#import "Book.h"

@implementation Book
+ (NSDictionary *)extendedPropertiesMapping {
    return @{@"numOfPages" : @"numofpages"};
}

+ (Book *)mock {
    Book *book = [Book new];
    book.objectId = @111;
    book.numOfPages = @1233;
    book.title = @"Mock is good";
    return book;
}
@end
