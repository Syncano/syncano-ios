//
//  SCDataObject.h
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle/Mantle.h"
#import "SCConstants.h"

@class Syncano;
@class SCPlease;
@class SCAPIClient;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Main class for data object from Syncano API.
 */
@interface SCDataObject : MTLModel<MTLJSONSerializing>
@property (nullable,nonatomic,copy) NSNumber *objectId;
@property (nullable,nonatomic,copy) NSDate *created_at;
@property (nullable,nonatomic,copy) NSDate *updated_at;
@property (nullable,nonatomic,copy) NSNumber *revision;
@property (nullable,nonatomic,copy) NSDictionary *links;
@property (nullable,nonatomic,copy) NSString *channel_room;
@property (nullable,nonatomic,copy) NSString *channel;
@property (nullable,nonatomic,copy) NSNumber *group;
@property (nullable,nonatomic,copy) NSNumber *owner;
@property (nonatomic) SCDataObjectPermissionType owner_permissions;
@property (nonatomic) SCDataObjectPermissionType group_permissions;
@property (nonatomic) SCDataObjectPermissionType other_permissions;

@property (nullable,nonatomic,readonly,getter=path) NSString *path;


/**
 *  Returns a class name used in Syncano API, by default this method converts object Class name to a lowercase string
 *
 *  @return String with API class name
 */
+ (NSString *)classNameForAPI;

/**
 *  Returns view name used in Syncano API, by default this method returns nil.
 *  Use it when you want to create a class which is always fetched using a view.
 *  When you set viewNameForAPI, [YourClass please] will target queries to the view instead of raw class.
 *
 *  @return String with API class name
 */
+ (nullable NSString *)viewNameForAPI;

/**
 *  Return custom property mapping between iOS class an API class
 *
 *  @return NSDictionary with 'key' of iOS class property name and 'value' with coresponding API class name
 */
+ (nullable NSDictionary *)extendedPropertiesMapping;

/**
 *  Returns SCPlease instance for singleton Syncano
 *
 *  @return SCPlease instance
 */
+ (nullable SCPlease *)please;

/**
 *  Returns SCPlease instance for provided Syncano instance
 *
 *  @param syncano Syncano instance which SCPlease will be using to query objects from
 *
 *  @return SCPlease instance
 */
+ (nullable SCPlease *)pleaseFromSyncano:(Syncano *)syncano;

/**
 *  Returns SCPlease instance for Syncano singleton
 *
 *  @param viewName Name of the Data Object View
 *
 *  @return SCPlease instance
 */
+ (nullable SCPlease *)pleaseForView:(NSString*)viewName;

/**
 *  Returns SCPlease instance for provided Syncano instance
 *
 *  @param viewName Name of the Data Object View
 *  @param syncano Syncano instance, which SCPlease will use to query objects from
 *
 *  @return SCPlease instance
 */
+ (nullable SCPlease *)pleaseForView:(NSString*)viewName fromSyncano:(Syncano *)syncano;

/**
 *  Registers class in SCParseManager for proper model parsing.
 */
+ (void)registerClass;

/**
 *  Returns an SCDataObject instance created by parsing the dictionary passed as a parameter
 *
 *  @param dictionary Dictionary with properties used to initialize new object
 *
 *  @return SCDataObject (or a subclass) created from provided dictionary
 */
+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary;

/**
 *  Saves an object using Syncano API in background, using Syncano Instance defined in default Syncano singleton
 *
 *  @param completion Completion block
 *
 */
- (void)saveWithCompletionBlock:(nullable SCCompletionBlock)completion;

/**
 *  Saves an object using Syncano API in background, using chosen Syncano instance
 *
 *  @param syncano    Saves object to API in background for provided Syncano instance
 *  @param completion completion block
 *
 */
- (void)saveToSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

- (void)saveWithCompletionBlock:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

- (void)saveToSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

/**
 *  Fetches an object from API using singleton Syncano instance
 *
 *  @param completion Completion block
 */
- (void)fetchWithCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Fetches an object from API using provided Syncano instance
 *
 *  @param syncano    Provided Syncano instance
 *  @param completion Completion block
 */
- (void)fetchFromSyncano:(Syncano *)syncano completion:(nullable SCCompletionBlock)completion;

/**
 *  Deletes an object in API using singleton Syncano instance
 *
 *  @param completion completion block
 */
- (void)deleteWithCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Deletes object in API using provided Syncano instance
 *
 *  @param syncano    provided Syncano instance
 *  @param completion completion block
 */
- (void)deleteFromSyncano:(Syncano *)syncano completion:(nullable SCCompletionBlock)completion;

/**
 *  Updates a value for provided key in API using singleton Syncano instance
 *
 *  @param value      Value
 *  @param key        Key to update
 *  @param completion Completion block
 */
- (void)updateValue:(id)value forKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Updates a value for provided key in API using provided Syncano instance
 *
 *  @param value      Value
 *  @param key        Key to update
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
- (void)updateValue:(id)value forKey:(NSString *)key inSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Updates value for a provided key in API using provided SCAPI client
 *
 *  @param value      Value
 *  @param key        Key to update
 *  @param apiClient  SCAPIClient
 *  @param completion Completion block
 */
- (void)updateValue:(id)value forKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Updatesa  value for provided key in API, using singleton Syncano instance and checking if there is no revision mismatch
 *
 *  @param value                 Value
 *  @param key                   Key to update
 *  @param completion            Comletion block
 *  @param revisionMismatchBlock Revision mismatch verification block
 */
- (void)updateValue:(id)value forKey:(NSString *)key withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

/**
 *  Updates a value for provided key in API using provided Syncano instance and checking if there is no revision mismatch
 *
 *  @param value                 Value
 *  @param key                   Key to pdate
 *  @param syncano               Syncano instance
 *  @param completion            Completion block
 *  @param revisionMismatchBlock Revision mismatch verification block
 */
- (void)updateValue:(id)value forKey:(NSString *)key inSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

/**
 *  Updates a value for provided key in API using provided SCAPIClient and checking if there is no revision mismatch
 *
 *  @param value                 Value
 *  @param key                   Key to update
 *  @param apiClient             SCAPIClient instance
 *  @param completion            Completion block
 *  @param revisionMismatchBlock Revision mismatch verification block
 */
- (void)updateValue:(id)value forKey:(NSString *)key usingAPIClient:(SCAPIClient *)apiClient withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

/**
 *  Increments NSNumber* property of given key by given value.
 *
 *  @param key        Property name of the class
 *  @param value      Can be a positive value (increment) or a negative value (decrement)
 *  @param completion Completion block
 */
- (void)incrementKey:(NSString*)key by:(NSNumber*)value withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Increments NSNumber* property of given key by given value.
 *
 *  @param key        Property name of the class
 *  @param value      Can be a positive value (increment) or a negative value (decrement)
 *  @param syncano    Provided Syncano instance
 *  @param completion Completion block
 */
- (void)incrementKey:(NSString*)key by:(NSNumber*)value inSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Increments NSNumber* property of given key by given value.
 *
 *  @param key                   Property name of the class
 *  @param value                 Can be a positive value (increment) or a negative value (decrement)
 *  @param completion            Completion block
 *  @param revisionMismatchBlock Revision mismatch block
 */
- (void)incrementKey:(NSString*)key by:(NSNumber*)value withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

/**
 *  Increments NSNumber* property of given key by given value.
 *
 *  @param key                   Property name of the class
 *  @param value                 Can be a positive value (increment) or a negative value (decrement)
 *  @param syncano               Provided Syncano instance
 *  @param completion            Completion block
 *  @param revisionMismatchBlock Revision mismatch block
 */
- (void)incrementKey:(NSString*)key by:(NSNumber*)value inSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

/**
 *  Increments properties of given keys by given values.
 *
 *  @param keys       Dictionary of properties which values should be incremeneted. Key of the dictionary is a property name. Example: @{@"downloads":@(1),@"items":@(-1)}
 *  @param completion Completion block
 */
- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Increments properties of given keys by given values.
 *
 *  @param keys       Dictionary of properties which values should be increased. Key of the dictionary is a property name. Example: @{@"downloads":@(1),@"items":@(-1)}
 *  @param syncano    Syncano instance
 *  @param completion Completion block
 */
- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys inSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion;

/**
 *  Increments properties of given keys by given values.
 *
 *  @param keys                   Dictionary of properties which values should be increased. Key of the dictionary is a property name. Example: @{@"downloads":@(1),@"items":@(-1)}
 *  @param completion             Completion block
 *  @param revisionMismatchBlock  Revision mismatch block
 */
- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;

/**
 *  Increments properties of given keys by given values.
 *
 *  @param keys                  Dictionary of properties which values should be increased. Key of the dictionary is a property name. Example: @{@"downloads":@(1),@"items":@(-1)}
 *  @param syncano               Syncano instance
 *  @param completion            Completion block
 *  @param revisionMismatchBlock Revision mismatch block
 */
- (void)incrementKeys:(NSDictionary<NSString*,NSNumber*>*)keys inSyncano:(Syncano *)syncano withCompletion:(nullable SCCompletionBlock)completion revisionMismatchValidationBlock:(nullable SCDataObjectRevisionMismatchCompletionBlock)revisionMismatchBlock;
@end
NS_ASSUME_NONNULL_END
