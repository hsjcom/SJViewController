//
//  ColorUtil.m
//  
//
//  Created by Soldier on 14-6-19.
//  Copyright (c) 2014年 Soldier. All rights reserved.
//

#import "ColorUtil.h"
#import "StringUtil.h"

@implementation ColorUtil
//16进制颜色(html颜色值)字符串转为UIColor
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    if ([StringUtil isEmpty:stringToConvert]) {
        return [UIColor blackColor];
    }

    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters

    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];

    int type = 0;
    if ([cString length] == 6) {
        type = 1;
    }
    else if ([cString length] == 8) {
        type = 2;
    }
    else {
        return [UIColor blackColor];
    }

    // Separate into r, g, b, a substrings

    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    range.location = 6;
    NSString *aString = nil;
    if (2 == type) {
        [cString substringWithRange:range];
    }

    // Scan values
    unsigned int r, g, b, a = 0.f;

    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    if (2 == type) {
        [[NSScanner scannerWithString:aString] scanHexInt:&a];
    }

    if (1 == type) {
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:((float) 255.0 / 255.0f)];
    }
    else if (2 == type) {
        return [UIColor colorWithRed:((float) r / 255.0f)
                               green:((float) g / 255.0f)
                                blue:((float) b / 255.0f)
                               alpha:((float) a / 255.0f)];
    }
    else
        return [UIColor blackColor];
}

@end
