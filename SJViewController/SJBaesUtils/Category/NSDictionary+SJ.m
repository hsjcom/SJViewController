//
//  NSDictionary+SJ.m
//  LifeStore
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "NSDictionary+SJ.h"

@implementation NSDictionary (SJ)

+ (void)setDict:(NSMutableDictionary *)dict value:(NSObject *)value forKey:(NSString *)key {
    if (!dict || ![dict isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    if (!value) {
        return;
    }
    if (!key || key.length <= 0) {
        return;
    }
    [dict setObject:value forKey:key];
}

+ (NSArray *)getArray:(NSDictionary *)dict key:(NSString *)key {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (![NSDictionary isNSNull:dict key:key]) {
        NSObject *value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            return (NSArray *) value;
        }
    }
    return nil;
}

+ (NSDictionary *)getDict:(NSDictionary *)dict key:(NSString *)key {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (![NSDictionary isNSNull:dict key:key]) {
        NSObject *value = [dict objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary *) value;
        }
    }
    return nil;
}

+ (NSNumber *)getNumber:(NSDictionary *)dict key:(NSString *)key {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSNumber *value = [NSNumber numberWithInt:0];
    if (![NSDictionary isNSNull:dict key:key]) {
        value = [dict objectForKey:key];
    }
    return value;
}

+ (BOOL)isNSNull:(NSDictionary *)responseDict key:(NSString *)key {
    if (!responseDict ||
        ![responseDict isKindOfClass:[NSDictionary class]] ||
        [responseDict isKindOfClass:[NSNull class]] ||
        [responseDict isEqual:[NSNull null]]) {
        return YES;
    }
    
    NSObject *value = [responseDict objectForKey:key];
    if (!value || [value isKindOfClass:[NSNull class]] || [value isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([value isKindOfClass:[NSNull class]] && [value isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)hasDictValue:(NSDictionary *)dictionary key:(NSString *)key {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSObject *obj = [dictionary objectForKey:key];
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSDictionary *dict = (NSDictionary *) obj;
    return dict.count > 0;
}

+ (BOOL)hasStringValue:(NSDictionary *)dictionary key:(NSString *)key {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSObject *obj = [dictionary objectForKey:key];
    if (![obj isKindOfClass:[NSString class]]) {
        return NO;
    }
    NSString *value = (NSString *) obj;
    return value.length > 0;
}

+ (BOOL)hasArrayValue:(NSDictionary *)dictionary key:(NSString *)key {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    NSObject *obj = [dictionary objectForKey:key];
    if (![obj isKindOfClass:[NSArray class]]) {
        return NO;
    }
    NSArray *array = (NSArray *)obj;
    return array.count > 0;
}

/**
 * 解析本地json文件，返回NSDictionary
 * parameter:本地json文件名称
 */
+ (NSDictionary *)responseForLocalJsonFile:(NSString *)jsonFileName {
    if ([StringUtil isEmpty:jsonFileName]) {
        return nil;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    return jsonDic;
}

@end
