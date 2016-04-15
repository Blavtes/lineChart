//
//  Created by SunX on 14-5-14.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "NSObject+Additions.h"

@implementation NSObject (GJSNSObjectAdditions)

- (void)GJSAutoSetPropertySafety:(NSDictionary *)item {
    if (!item||![item isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //获取所有property
    [self setClassProperty:[self class] withPropertyDic:item];
    
    
    if (self.superclass) {
        [self setClassProperty:self.superclass withPropertyDic:item];
    }
}

- (void)setClassProperty:(Class)class withPropertyDic:(NSDictionary *)item {
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id valueItem = item[propertyName];
        if (valueItem) {
            //获取该property的数据类型
            const char* attries = property_getAttributes(property);
            NSString *attrString = [NSString stringWithUTF8String:attries];
            [self GJSSetPropery:attrString value:valueItem propertyName:propertyName];
        }
    }
    if(properties) free(properties);
}

- (void)GJSResetAllProperty {
    //获取所有property
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        //获取该property的数据类型
        const char* attries = property_getAttributes(property);
        NSString *attrString = [NSString stringWithUTF8String:attries];
        if ([attrString hasPrefix:@"T@"]) {
            [self setValue:nil forKey:propertyName];
        }
    }
    if(properties) free(properties);
}

- (void)GJSSetPropery:(NSString *)attriString
               value:(id)value
        propertyName:(NSString *)propertyName{
    //kvc不支持c的数据类型，所以只能NSNumber转化，NSNumber可以  64位是TB
    if ([attriString hasPrefix:@"T@\"NSString\""]) {
        [self setValue:GJSToString(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tc"] || [attriString hasPrefix:@"TB"]) {
        //32位Tc  64位TB
        [self setValue:[NSNumber numberWithBool:[value boolValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Ti"] || [attriString hasPrefix:@"Tq"]) {
        //32位 Ti是int 和 NSInteger  64位后，long 和  NSInteger 都是Tq， int 是Ti
        [self setValue:[NSNumber numberWithInteger:[GJSToString(value) integerValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"TQ"] || [attriString hasPrefix:@"TI"]) {
        [self setValue:[NSNumber numberWithInteger:[GJSToString(value) integerValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tl"]) { //32位 long
        [self setValue:[NSNumber numberWithLongLong:[GJSToString(value) longLongValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tf"]) { //float
        [self setValue:[NSNumber numberWithFloat:[GJSToString(value) floatValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Td"]) { //CGFloat
        [self setValue:[NSNumber numberWithDouble:[GJSToString(value) doubleValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableArray\""]) {
        [self setValue:GJSToMutableArray(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSArray\""]) {
        [self setValue:GJSToArray(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSDictionary\""]) {
        [self setValue:GJSToDictionary(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableDictionary\""]) {
        [self setValue:GJSToMutableDictionary(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSNumber\""]) {
        [self setValue:@([GJSToString(value) integerValue]) forKey:propertyName];
    }
}

- (NSMutableDictionary *)GJSAllPropertiestAndValues {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([self valueForKey:propertyName]) {
            [props setObject:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    if(properties) free(properties);
    return props;
}

- (NSString *)GJSJsonEncode {
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSMutableArray class]] ||
        [self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSMutableDictionary class]]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)GJSObjectFortKeySafe:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]) {
        return [(NSDictionary*)self objectForKey:key];
    }
    return nil;
}

- (id)GJSObjectIndexSafe:(NSUInteger)index {
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]) {
        if (index < [(NSArray*)self count]) {
            return [(NSArray*)self objectAtIndex:index];
        }
        return nil;
    }
    return nil;
}

@end


/**
 *  数据校验
 */
NSString* GJSToString(id obj) {
    return [obj isKindOfClass:[NSObject class]]?[NSString stringWithFormat:@"%@",obj]:@"";
}

NSArray* GJSToArray(id obj)  {
    return [obj isKindOfClass:[NSArray class]]?obj:nil;
}

NSDictionary* GJSToDictionary(id obj) {
    return [obj isKindOfClass:[NSDictionary class]]?obj:nil;
}

NSMutableArray* GJSToMutableArray(id obj)   {
    return [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]] ? [NSMutableArray arrayWithArray:obj] :nil;
}

NSMutableDictionary* GJSToMutableDictionary(id obj)  {
    return [obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]] ? [NSMutableDictionary dictionaryWithDictionary:obj] : nil;
}



