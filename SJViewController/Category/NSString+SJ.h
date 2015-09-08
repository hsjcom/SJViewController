//
//  NSString+SJ.h
//
//
//  Created by Soldier on 15-1-30.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SJ)

- (NSString *)md5Hash;

- (NSString *)sha1Hash;

+ (BOOL)isEmpty:(NSString *)value;

+ (NSString *)ifNilToStr:(NSString *)value;

+ (NSString *)stringWithInteger:(NSInteger)value;

+ (NSString *)stringWithLong:(long)value;

+ (NSString *)stringWithLongLong:(int64_t)value;

+ (NSString *)stringWithFloat:(float)value;

+ (NSString *)stringWithDouble:(double)value;

/////////////////////////////////////////////////////////////////////////////////////////////////// @"!$&'()*+,-./:;=?@_~%#[]",
- (NSString *)urlEncoded;

@end
