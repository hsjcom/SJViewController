//
//  ValueValidator.m
//
//
//  Created by Soldier on 12-5-9.
//  Copyright (c) 2012年 Soldier. All rights reserved.
//

#import "ValueValidator.h"

@implementation ValueValidator

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

+ (BOOL)isNuLLForArray:(NSArray *)array {
    if (!array || [array isKindOfClass:[NSNull class]] || [array isEqual:[NSNull null]]) {
        return YES;
    }

    if (![array isKindOfClass:[array class]]) {
        return YES;
    }

    if ([array count] == 0) {
        return YES;
    }

    return NO;
}

+ (BOOL)isNuLLForSet:(NSSet *)set {
    if (!set || [set isKindOfClass:[NSNull class]] || [set isEqual:[NSNull null]]) {
        return YES;
    }

    if (![set isKindOfClass:[NSSet class]]) {
        return YES;
    }

    if ([set count] == 0) {
        return YES;
    }

    return NO;
}

@end
