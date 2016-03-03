//
//  NSString+SJ.m
//
//
//  Created by Soldier on 15-1-30.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "NSString+SJ.h"
#import "NSData+SJ.h"

@implementation NSString (SJ)

- (NSString *)md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}

- (NSString *)sha1Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1Hash];
}

+ (BOOL)isEmpty:(NSString *)value {
    if ((value == nil) || value == (NSString *)[NSNull null] || (value.length == 0))
    {
        return YES;
    }
    return NO;
}

+ (NSString *)ifNilToStr:(NSString *)value {
    if ((value == nil) || (value == (NSString *)[NSNull null]))
    {
        return @"";
    }
    return value;
}

+ (NSString *)stringWithInteger:(NSInteger)value {
    NSNumber *number = [NSNumber numberWithInteger:value];
    return [number stringValue];
}

+ (NSString *)stringWithLong:(long)value {
    return [NSString stringWithFormat:@"%ld", value];
}

+ (NSString *)stringWithLongLong:(int64_t)value {
    return [NSString stringWithFormat:@"%lld", value];
}

+ (NSString *)stringWithFloat:(float)value {
    return [NSString stringWithFormat:@"%f", value];
}

+ (NSString *)stringWithDouble:(double)value {
    return [NSString stringWithFormat:@"%lf", value];
}

/////////////////////////////////////////////////////////////////////////////////////////////////// @"!$&'()*+,-./:;=?@_~%#[]",
- (NSString *)urlEncoded {
    CFStringRef cfUrlEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                             (CFStringRef)self,NULL,
                                                                             (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                             kCFStringEncodingUTF8);
    
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString *)cfUrlEncodedString];
    CFRelease(cfUrlEncodedString);
    return urlEncoded;
}

@end
