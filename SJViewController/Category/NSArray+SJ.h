//
//  NSArray+SJ.h
//  LifeStore
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SJ)

+ (void)addToArray:(NSMutableArray *)array value:(NSObject *)value;

+ (void)addToArray:(NSMutableArray *)array fromArray:(NSArray *)otherArray;

+ (void)removeFromArray:(NSMutableArray *)array value:(NSObject *)value;

+ (void)removeFromArray:(NSMutableArray *)array inArray:(NSArray *)otherArray;

+ (BOOL)isNuLLForArray:(NSArray *)array;

@end
