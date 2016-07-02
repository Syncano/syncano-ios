//
//  SCDataObjectSpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import "Book.h"
#import "Message.h"
#import "Device.h"

#import "CustomUserProfile.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "SCJSONHelper.h"
#import "OHPathHelpers.h"

@interface SCRegisterManager (SCParseManagerSpec)

+ (NSMutableArray *)registeredClasses;

@end

SPEC_BEGIN(SCParseManagerSpec)

describe(@"SCParseManager", ^{
    
    it(@"should return type name string of provided property name inside provided class", ^{
        NSString *typeName =  [SCParseManager typeOfPropertyNamed:@"author" fromClass:[Book class]];
        [[typeName should] equal:@"Author"];
    });
    
    it(@"should validate and set value to object", ^{
        Book *book = [Book new];
        SCValidateAndSetValue(book, @"objectId", @12, YES, nil);
        [[book.objectId should] equal:@12];
    });
    context(@"SCDataObjectContext", ^{
        it(@"should parse object from JSON NSDictionary", ^{
            NSDictionary *JSON = @{@"id" : @123,};
            Book *dataObject = [[SCParseManager sharedSCParseManager] parsedObjectOfClass:[Book class] fromJSONObject:JSON];
            [[dataObject.objectId should] equal:@123];
        });
        
        it(@"should parse objects from of JSON NSDictionary with more than one object", ^{
            NSArray *JSON = @[@{@"id" : @123}, @{@"id" : @124}];
            NSArray *dataObjects = [[SCParseManager sharedSCParseManager] parsedObjectsOfClass:[Book class] fromJSONObject:JSON];
            [[theValue(dataObjects.count) should] equal:theValue(2)];
            Book *book = [dataObjects lastObject];
            [[book.objectId should] equal:@124];
        });
        
        it(@"should parse objects from JSON and resolve relations", ^{
            NSString* path = OHPathForFile(@"ViewResponse.json",self.class);
            NSData* content = [NSData dataWithContentsOfFile:path];
            id JSON = [NSJSONSerialization JSONObjectWithData:content
                                                      options:NSJSONReadingMutableContainers
                                                        error:NULL];
            [Device registerClass];
            [Message registerClass];
            NSArray *dataObjects = [[SCParseManager sharedSCParseManager] parsedObjectsOfClass:[Message class] fromJSONObject:JSON[@"objects"]];
            [[theValue(dataObjects.count) should] equal:theValue(2)];
            
            for(Message* msg in dataObjects) {
                [[msg should] beKindOfClass:[Message class]];
                [[msg.device should] beKindOfClass:[Device class]];
            }
        });
        
        it(@"should fill object from JSON NSDictionary", ^{
            NSDictionary *JSON = @{@"id" : @12,@"numofpages" : @223 , @"title" : @"syncano for geeks"};
            Book *book = [Book new];
            book.objectId = @12;
            book.numOfPages = @123;
            [[SCParseManager sharedSCParseManager] fillObject:book withDataFromJSONObject:JSON];
            [[book.numOfPages should] equal:@223];
            [[book.title should] equal:@"syncano for geeks"];
            [[book.objectId should] equal:@12];
        });
        
        it(@"should convert data object to NSDictionary representation", ^{
            NSError *error;
            
            Book *book = [Book new];
            book.objectId = @12;
            book.numOfPages = @123;
            book.title = @"syncano for geeks";
            
            NSDictionary *dictionaryRepresentation = [[SCParseManager sharedSCParseManager] JSONSerializedDictionaryFromDataObject:book error:&error];
            
            [[dictionaryRepresentation should] beNonNil];
            [[dictionaryRepresentation[@"numofpages"] should] equal:@123];
            [[dictionaryRepresentation[@"title"] should] equal:@"syncano for geeks"];
            [[error should] beNil];
            
        });
        
        it(@"should register class", ^{
            
            [SCRegisterManager registerClass:[Book class]];
            
            SCClassRegisterItem *registeredItem = [SCRegisterManager registeredItemForClass:[Book class]];
            
            [[registeredItem should] beNonNil];
            [[registeredItem.className should] equal:@"Book"];
            [[registeredItem.classNameForAPI should] equal:@"book"];
            [[registeredItem.properties[@"author"] should] equal:@"Author"];
        });
        
        it(@"should return realtions for Book class", ^{
            [SCRegisterManager registerClass:[Book class]];
            [SCRegisterManager registerClass:[Author class]];
            
            NSDictionary *relations = [SCRegisterManager relationsForClass:[Book class]];
            
            [[relations should] beNonNil];
            [[relations[@"author"] should] beKindOfClass:[SCClassRegisterItem class]];
        });
        
    });
    
    context(@"SCUser context", ^{
        it(@"should register user class", ^{
            [[SCParseManager sharedSCParseManager] registerUserClass:[SCUser class]];
            [[[[SCParseManager sharedSCParseManager] userClass] should] equal:[SCUser class]];
        });
        it(@"should register user profile class", ^{
            [[SCParseManager sharedSCParseManager] registerUserProfileClass:[CustomUserProfile class]];
            [[[[SCParseManager sharedSCParseManager] userProfileClass] should] equal:[CustomUserProfile class]];
        });
        it(@"should parse user object from JSON object", ^{
            id JSON = [SCJSONHelper JSONObjectFromFileWithName:@"SCUser"];
            SCUser *user = [[SCParseManager sharedSCParseManager] parsedUserObjectFromJSONObject:JSON];
            [[user should] beNonNil];
            [[user.userId should] equal:@6];
            [[user.profile should] beNonNil];
            [[user.profile.objectId should] equal:@24];
        });
    });
});

SPEC_END
