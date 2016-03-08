//
//  SCParseManager.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 30/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "SCParseManager.h"
#import "Mantle/Mantle.h"
#import <objc/runtime.h>
#import "SCDataObject.h"
#import "SCReferencesStore.h"

@interface SCParseManager ()

@end

@implementation SCParseManager

SINGLETON_IMPL_FOR_CLASS(SCParseManager)

- (instancetype)init {
    self = [super init];
    if (self) {
        referencesStore = [[SCReferencesStore alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableWeakMemory capacity:0];
    }
    return self;
}

/**
 Pass mangled class name from Swift and extract demangled one - in format of Namespace.Classname
 */
+ (NSString *)demangleClassName:(NSString *)mangled {
    NSScanner *scanner = [[NSScanner alloc] initWithString:mangled];
    scanner.scanLocation = 0;
    if (![scanner scanString:@"_TtC" intoString:nil]) {
        // not a mangled swift class name: Core Foundation, etc. have no module prefix
        return mangled;
    }
    NSMutableString *demangled = [NSMutableString new];
    NSInteger length = 0;
    
    while(!scanner.atEnd && [scanner scanInteger:&length]) {
        NSRange range = NSMakeRange(scanner.scanLocation, length);
        NSString *part = [mangled substringWithRange:range];
        if (demangled.length > 0) {
            [demangled appendString:@"."];
        }
        [demangled appendString:part];
        scanner.scanLocation += length;
    }
    return [demangled copy];
}

/**
 Gets class name from demangled name - extracts Classname from Namespace.Classname format
 */
+ (NSString *)classNameFromDemangledName:(NSString *)demangledName {
    if ([demangledName rangeOfString:@"."].location != NSNotFound) {
        demangledName = [demangledName componentsSeparatedByString:@"."].lastObject;
    }
    return demangledName;
}

+ (NSString *)typeOfPropertyNamed:(NSString *)name fromClass:(__unsafe_unretained Class)aClass
{
    objc_property_t property = class_getProperty( aClass, [name UTF8String] );
    if ( property == NULL )
        return ( NULL );
    NSString *typeName = [NSString stringWithUTF8String:property_getTypeString(property)];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"T@\"" withString:@""];
    typeName = [typeName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    typeName = [self classNameFromDemangledName:[self demangleClassName:typeName]];
    return typeName;
}

/**
 *  Converts objc_property_t to const char *
 *
 *  @param property objc_property_t to convert
 *
 *  @return converted const char *
 */
const char * property_getTypeString( objc_property_t property )
{
    const char * attrs = property_getAttributes( property );
    if ( attrs == NULL )
        return ( NULL );
    
    static char buffer[256];
    const char * e = strchr( attrs, ',' );
    if ( e == NULL )
        return ( NULL );
    
    int len = (int)(e - attrs);
    memcpy( buffer, attrs, len );
    buffer[len] = '\0';
    
    return ( buffer );
}

@end
