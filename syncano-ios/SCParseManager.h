//
//  SCParseManager.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "SCMacros.h"
#import "SCConstants.h"
#import "Mantle/NSError+MTLModelException.h"

/**
 *  Validates a value for an object and sets it if necessary. Method copied from Mantle
 *
 *  @param obj         The object for which the value is being validated. This value must not be nil.
 *  @param key         The name of one of `obj`s properties. This value must not be nil.
 *  @param value       The new value for the property identified by `key`.
 *  @param forceUpdate If set to `YES`, the value is being updated even if validating it did not change it.
 *  @param error       If not NULL, this may be set to any error that occurs during validation
 *
 *  @return YES if `value` could be validated and set, or NO if an error occurred.
 */
static inline BOOL SCValidateAndSetValue(id obj, NSString *key, id value, BOOL forceUpdate, NSError **error) {
    // Mark this as being autoreleased, because validateValue may return
    // a new object to be stored in this variable (and we don't want ARC to
    // double-free or leak the old or new values).
    __autoreleasing id validatedValue = value;
    
    @try {
        if (![obj validateValue:&validatedValue forKey:key error:error]) return NO;
        
        if (forceUpdate || value != validatedValue) {
            [obj setValue:validatedValue forKey:key];
        }
        
        return YES;
    } @catch (NSException *ex) {
        NSLog(@"*** Caught exception setting key \"%@\" : %@", key, ex);
        
        // Fail fast in Debug builds.
#if DEBUG
        @throw ex;
#else
        if (error != NULL) {
            *error = [NSError mtl_modelErrorWithException:ex];
        }
        
        return NO;
#endif
    }
}



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



/**
 *  Singleton class for SCDataObject parsing
 */
@interface SCParseManager : NSObject

/**
 *  Array of SCClassRegisterItems
 */
@property (nonatomic,retain) NSMutableArray *registeredClasses;

/**
 *  Initializes singleton
 */
SINGLETON_FOR_CLASS(SCParseManager);

/**
 *  Returns type of property from provided class
 *
 *  @param name  property name
 *  @param class
 *
 *  @return property type string or NULL
 */
- (NSString *) typeOfPropertyNamed: (NSString *) name fromClass:(__unsafe_unretained Class)class;


/**
 *  Registers class for subclassing
 *
 *  @param classToRegister
 */
- (void)registerClass:(__unsafe_unretained Class)classToRegister;

/**
 *  Returns registered item for provided class
 *
 *  @param registeredClass class to look up register for
 *
 *  @return SCClassRegisterItem for provided class or nil
 */
- (SCClassRegisterItem *)registeredItemForClass:(__unsafe_unretained Class)registeredClass;

/**
 *  Returns relations for provided class
 *
 *  @param class provided class
 *
 *  @return NSDictionary with property name as 'key' and SCClassRegisterItem as 'value' or empty NSDictionary if there are no relations
 */
- (NSDictionary *)relationsForClass:(__unsafe_unretained Class)class;


@end

