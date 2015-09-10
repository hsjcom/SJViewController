//
//  NSArray+SJ.m
//  LifeStore
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "NSArray+SJ.h"

@implementation NSArray (SJ)

+ (void)addToArray:(NSMutableArray *)array value:(NSObject *)value {
    if (!array || ![array isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    if (!value) {
        return;
    }
    
    [array addObject:value];
}

+ (void)addToArray:(NSMutableArray *)array fromArray:(NSArray *)otherArray {
    if (!array || ![array isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    if (!otherArray || ![otherArray isKindOfClass:[NSArray class]]) {
        return;
    }
    
    [array addObjectsFromArray:otherArray];
}

+ (void)removeFromArray:(NSMutableArray *)array value:(NSObject *)value {
    if (!array || ![array isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    if (!value) {
        return;
    }
    
    if ([array indexOfObject:value] != NSNotFound) {
        [array removeObject:value];
    }
}

+ (void)removeFromArray:(NSMutableArray *)array inArray:(NSArray *)otherArray {
    if (!array || ![array isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    if (!otherArray || ![otherArray isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    
    [array removeObjectsInArray:otherArray];
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


@end
