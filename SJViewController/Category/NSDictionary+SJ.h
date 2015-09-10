//
//  NSDictionary+SJ.h
//  LifeStore
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SJ)

+ (void)setDict:(NSMutableDictionary *)dict value:(NSObject *)value forKey:(NSString *)key;

+ (NSArray *)getArray:(NSDictionary *)dict key:(NSString *)key;

+ (NSDictionary *)getDict:(NSDictionary *)dict key:(NSString *)key;

+ (NSNumber *)getNumber:(NSDictionary *)dict key:(NSString *)key;

+ (BOOL)isNSNull:(NSDictionary *)responseDict key:(NSString *)key;

+ (BOOL)hasDictValue:(NSDictionary *)dictionary key:(NSString *)key;

+ (BOOL)hasStringValue:(NSDictionary *)dictionary key:(NSString *)key;

+ (BOOL)hasArrayValue:(NSDictionary *)dictionary key:(NSString *)key;

/**
 * 解析本地json文件，返回NSDictionary
 * parameter:本地json文件名称
 */
+ (NSDictionary *)responseForLocalJsonFile:(NSString *)jsonFileName;

@end
