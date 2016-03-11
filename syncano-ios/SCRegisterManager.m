//
//  SCRegisterManager.m
//  syncano-ios
//
//  Created by Jan Lipmann on 11/11/15.
//  Copyright © 2015 Syncano. All rights reserved.
//

#import "SCRegisterManager.h"
#import "SCDataObject+Properties.h"
#import "SCParseManager.h"

@implementation SCClassRegisterItem
@end

@interface SCRegisterManager()

+ (NSMutableArray *)registeredClasses;
+ (NSMutableDictionary<NSString*,NSDictionary*> *)relationsForClass;

@end

@implementation SCRegisterManager

+ (NSMutableArray *)registeredClasses {
    static NSMutableArray* registeredClasses = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        registeredClasses = [NSMutableArray new];
    });
    
    return registeredClasses;
}

+ (NSMutableDictionary<NSString*,NSDictionary*> *)relationsForClass {
    static NSMutableDictionary<NSString*,NSDictionary*>* relationsForClass = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        relationsForClass = [NSMutableDictionary dictionary];
    });
    
    return relationsForClass;
}

+ (NSDictionary *)relationsForClass:(__unsafe_unretained Class)aClass {
    NSString *className = [self normalizedClassNameFromClass:aClass];
    NSDictionary *relations = [self relationsForClass][className];
    if(relations == nil) {
        relations = [self relationsForClassItem:[self registerItemForClassName:className]];
        [self relationsForClass][className] = relations;
    }
    return relations;
}

+ (NSDictionary *)relationsForClassItem:(SCClassRegisterItem *)registerForClass {
    NSMutableDictionary *relations = [NSMutableDictionary new];
    for (NSString *propertyName in registerForClass.properties.allKeys) {
        NSString *propertyType = registerForClass.properties[propertyName];
        SCClassRegisterItem *item = [self registerItemForClassName:propertyType];
        if (item) {
            [relations setObject:item forKey:propertyName];
        }
    }
    return relations;
}

+ (void)refreshRelationsForRegisteredClasses {
    [[self relationsForClass] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        [self relationsForClass][key] = [self relationsForClassItem:[self registerItemForClassName:key]];
    }];
}

+ (void)registerClass:(__unsafe_unretained Class)classToRegister {
    if ([classToRegister respondsToSelector:@selector(propertyKeys)]) {
        NSSet *properties = [classToRegister propertyKeys];
        NSMutableDictionary *registeredProperties = [[NSMutableDictionary alloc] initWithCapacity:properties.count];
        NSString *classNameForAPI;
        if ([classToRegister respondsToSelector:@selector(classNameForAPI)]) {
            classNameForAPI = [classToRegister classNameForAPI];
        }
        for (NSString *property in properties) {
            NSString *typeName = [SCParseManager typeOfPropertyNamed:property fromClass:classToRegister];
            [registeredProperties setObject:typeName forKey:property];
        }
        SCClassRegisterItem *registerItem = [SCClassRegisterItem new];
        registerItem.classNameForAPI = classNameForAPI;
        registerItem.className = [[self class] normalizedClassNameFromClass:classToRegister];
        registerItem.properties = registeredProperties;
        registerItem.classReference = classToRegister;
        [self.registeredClasses addObject:registerItem];
        [self refreshRelationsForRegisteredClasses];
    }
}

/**
 *  Returns register for provided Class
 *
 *  @param registeredClass class too look up for
 *
 *  @return SCClassRegisterItem or nil
 */
+ (SCClassRegisterItem *)registeredItemForClass:(__unsafe_unretained Class)registeredClass {
    return [self registerItemForClassName:[[self class] normalizedClassNameFromClass:registeredClass]];
}

/**
 *  Returns register for provided Class name
 *
 *  @param className class name too look up for
 *
 *  @return SCClassRegisterItem or nil
 */
+ (SCClassRegisterItem *)registerItemForClassName:(NSString *)className {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"className == %@",className];
    SCClassRegisterItem *item = [[self.registeredClasses filteredArrayUsingPredicate:predicate] lastObject];
    return item;
}

+ (NSString *)normalizedClassNameFromClass:(__unsafe_unretained Class)class {
    return [[NSStringFromClass(class) componentsSeparatedByString:@"."] lastObject];
}


@end
