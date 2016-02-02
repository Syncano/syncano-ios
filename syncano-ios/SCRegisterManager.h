//
//  SCRegisterManager.h
//  syncano-ios
//
//  Created by Jan Lipmann on 11/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class contains info about registered class for subclassing
 */
@interface SCClassRegisterItem : NSObject
/**
 *  Name of class using in Syncano
 */
@property (nonatomic,copy) NSString *classNameForAPI;

/**
 *  Local reference of subslassed class
 */
@property (nonatomic, copy) Class classReference;
/**
 *  Local name of subslassed class
 */
@property (nonatomic,copy) NSString *className;
/**
 *  Dictionary stores property names as keys and type names as values
 */
@property (nonatomic,copy) NSDictionary *properties;
@end


@interface SCRegisterManager : NSObject



+ (NSMutableArray *)registeredClasses;


/**
 *  Registers class for subclassing
 *
 *  @param classToRegister
 */
+ (void)registerClass:(__unsafe_unretained Class)classToRegister;

/**
 *  Returns registered item for provided class
 *
 *  @param registeredClass class to look up register for
 *
 *  @return SCClassRegisterItem for provided class or nil
 */
+ (SCClassRegisterItem *)registeredItemForClass:(__unsafe_unretained Class)registeredClass;

/**
 *  Returns relations for provided class
 *
 *  @param class provided class
 *
 *  @return NSDictionary with property name as 'key' and SCClassRegisterItem as 'value' or empty NSDictionary if there are no relations
 */
+ (NSDictionary *)relationsForClass:(__unsafe_unretained Class)class;

@end
