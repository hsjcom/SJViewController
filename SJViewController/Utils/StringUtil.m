//
//  StringUtil.m
//
//
//  Created by Soldier on 12-5-25.
//  Copyright (c) 2012年 Soldier. All rights reserved.
//

#import "StringUtil.h"
#import "ValueValidator.h"
#import "NSData+SJ.h"
#import "NSString+SJ.h"

@implementation StringUtil

+ (NSString *)urlEncode:(NSString *)str {

    return [[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}

+ (NSString *)urlDecode:(NSString *)str {
    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


+ (BOOL)isStringWithAnyText:(id)object {
    return [object isKindOfClass:[NSString class]] && [(NSString *) object length] > 0;
}

+ (NSString *)trimWhitespace:(NSString *)str {
    if (str != nil && (NSNull *) str != [NSNull null] && [str isKindOfClass:[NSString class]]) {
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return nil;
}

//去除所有空格，包括头尾，中间
+ (NSString *)trimAllWhitespace:(NSString *)str {
    if (str != nil && (NSNull *) str != [NSNull null] && [str isKindOfClass:[NSString class]]) {
        NSString *spaceStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return [spaceStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return nil;
}

+ (NSString *)getString:(NSDictionary *)dict key:(NSString *)key {
    NSString *value = @"";
    if (![ValueValidator isNSNull:dict key:key]) {
        NSString *str = [self trimWhitespace:[dict objectForKey:key]];
        if ([StringUtil isStringWithAnyText:str] && ![@"null" isEqualToString:str]) {
            value = str;
        }
    }
    return value;
}

+ (NSString *)getStringForNull:(NSDictionary *)dict key:(NSString *)key {
    NSString *value = nil;
    if (![ValueValidator isNSNull:dict key:key]) {
        NSString *str = [self trimWhitespace:[dict objectForKey:key]];
        if ([StringUtil isStringWithAnyText:str] && ![@"null" isEqualToString:str]) {
            value = str;
        }
    }
    return value;
}

+ (NSString *)getStringForNotNull:(NSString *)inparam {
    NSString *string = @"";
    if (inparam != nil && (NSNull *) inparam != [NSNull null] && [inparam isKindOfClass:[NSString class]]) {
        string = inparam;
    }
    return string;
}

+ (NSString *)getStringForType:(NumType)numType dic:(NSDictionary *)dict key:(NSString *)key{
    if ([ValueValidator isNSNull:dict key:key]) {
        return nil;
    }
    
    id value = [dict objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        switch (numType) {
            case LONG_TYPE:
                return [NSString stringWithFormat:@"%lli",[value longLongValue]];
                break;
            case FLOAT_TYTP:
                return [NSString stringWithFormat:@"%.2f",[value floatValue]];
                break;
            case INT_TYTP:
                return [NSString stringWithFormat:@"%d",[value intValue]];
                break;
            case DOUBLE_TYTP:
                return [NSString stringWithFormat:@"%.2f",[value doubleValue]];
                break;
            case BOOL_TYPE:
                return [NSString stringWithFormat:@"%d",[value boolValue]];
                break;
            default:
                break;
        }
        
    }
    
    return nil;
}

+ (NSNumber *)getNumberForType:(NumType)numType  dic:(NSDictionary *)dict key:(NSString *)key {
    
    if ([ValueValidator isNSNull:dict key:key]) {
        return nil;
    }
    
    id value = [dict objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        switch (numType) {
            case LONG_TYPE:
            //勿改，NSString类型无longValue方法会出现闪退
                return [NSNumber numberWithLongLong:[value longLongValue]];
                break;
            case FLOAT_TYTP:
                return [NSNumber numberWithFloat:[value floatValue]];
                break;
            case INT_TYTP:
                return [NSNumber numberWithInteger:[value integerValue]];
                break;
            case DOUBLE_TYTP:
                return [NSNumber numberWithDouble:[value doubleValue]];
                break;
            case BOOL_TYPE:
                return [NSNumber numberWithBool:[value boolValue]];
                break;
            default:
                break;
        }
        
    }

    return nil;
}



+ (NSNumber *)getNumberFromString:(NSDictionary *)dict key:(NSString *)key {
    NSString *value = nil;
    if (![ValueValidator isNSNull:dict key:key]) {
        NSString *str = [self trimWhitespace:[dict objectForKey:key]];
        if ([StringUtil isStringWithAnyText:str] && ![@"null" isEqualToString:str]) {
            value = str;
        }
    }
    if (![StringUtil isStringWithAnyText:value]) {
        return nil;
    }
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    NSNumber *result = [f numberFromString:value];
    return result;
}

+ (NSString *)trimHTMLTag:(NSString *)str {
    if (![StringUtil isStringWithAnyText:str]) {
        return @"";
    }
    NSScanner *theScanner;
    NSString *text = nil;

    theScanner = [NSScanner scannerWithString:str];

    while (![theScanner isAtEnd]) {

        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL];

        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text];

        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        str = [str stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                             withString:@""];

    } // while //

    return str;
}

+ (BOOL)isEmpty:(NSString *)str {
    NSString *trim = [StringUtil trimWhitespace:str];
    return ![StringUtil isStringWithAnyText:trim];
}

+ (NSString *)replaceNewlineAndBreak:(NSString *)str {
    NSRange range = [[str lowercaseString] rangeOfString:@"\\r\\n"];
    if (range.location == NSNotFound) {
        return str;
    }
    return [str stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\r\n"];
}

+ (NSString *)encodeNewLineAndBreak:(NSString *)str {
    NSString *lowercaseString = [str lowercaseString];
    NSString *resultString = str;
    NSRange range1 = [lowercaseString rangeOfString:@"\r"];
    if (range1.location != NSNotFound) {
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    }

    NSRange range2 = [lowercaseString rangeOfString:@"\n"];
    if (range2.location != NSNotFound) {
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    }

    return resultString;
}

+ (BOOL)isTelIegal:(NSString *)tel {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([0-9]*[-_]?[0-9]+)?$" options:(NSRegularExpressionOptions) 0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:tel options:(NSMatchingOptions) 0 range:NSMakeRange(0, [tel length])];
        if (firstMatch) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isPriceIegal:(NSString *)price {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]*[.]?[0-9]*$" options:(NSRegularExpressionOptions) 0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:price options:(NSMatchingOptions) 0 range:NSMakeRange(0, [price length])];
        if (firstMatch) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isLegal:(NSString *)str regex:(NSString *)regex {
    NSRegularExpression *regularexpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    return numberofMatch > 0;
}

+ (BOOL)isEmailLegal:(NSString *)str {
    return [self isLegal:str regex:@"^([a-zA-Z0-9]*[-_.]?[a-zA-Z0-9]+)@([a-zA-Z0-9]*[-_]?[a-zA-Z0-9]+)+[\\.][A-Za-z]{2,3}([\\.][A-Za-z]{2})?$"];
}

+ (BOOL)isNickLegal:(NSString *)str {
    return [self isLegal:str regex:@"^[a-zA-Z0-9_\u0391-\uFFE5]+$"];
}

//中文数字_ && 非纯数字 && 不包含“@”
+ (BOOL)isNickLegal2:(NSString *)str {
    BOOL isContain;
    NSRange foundObj = [str rangeOfString:@"@" options:NSCaseInsensitiveSearch];
    if(foundObj.length > 0) {
        isContain = YES;
    } else {
        isContain = NO;
    }
    
    return [StringUtil isNickLegal:str] && ![StringUtil isNumber:str] && (!isContain);
}

+ (BOOL)isNumber:(NSString *)str {
    return [self isLegal:str regex:@"^[0-9]*$"];
}

+ (BOOL)isPhoneNumber:(NSString *)str {
    /**
     * 手机号码
     *新：不限制开头字样
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188（废弃）
     * 联通：130,131,132,152,155,156,185,186（废弃）
     * 电信：133,1349,153,180,189（废弃）
     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    return [self isLegal:str regex:@"^((1(3[0-9]|4[0-9]|5[0-35-9]|8[0-9])\\d{8})|(0(10|2[0-5789]|\\d{3})\\d{7,8}))$"];
    return [self isLegal:str regex:@"^((1\\d{10})|(0(10|2[0-5789]|\\d{3})\\d{7,8}))$"];
}

+ (BOOL)isMobileNumber:(NSString *)str {
    //以1开头的11位手机号码
    return [self isLegal:str regex:@"^((1\\d{10}))$"];
}

+ (BOOL)isHyperLink:(NSString *)URL {
    return [URL hasPrefix:@"http://"] || [URL hasPrefix:@"https://"];
}

+ (BOOL)hasChar:(NSString *)str {
    return [self isLegal:str regex:@"[‘’“”\\.]"];
}


+ (NSDictionary *)dictFromReqParam:(NSString *)string {
    if ([StringUtil isEmpty:string]) {
        return nil;
    }
    NSArray *stringArray = [string componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    for (NSString *divString in stringArray) {
        NSArray *array = [divString componentsSeparatedByString:@"="];
        if ([array count] != 2)continue;
        NSString *encode = [array objectAtIndex:1];
        NSString *decode = [StringUtil urlDecode:encode];//返回网页时，服务端decode相关数据
        [info setObject:decode forKey:[array objectAtIndex:0]];
    }
    return [NSDictionary dictionaryWithDictionary:info];
}

+ (NSString *)getParamFromJsonURL:(NSString *)url andParamKey:(NSString *)key {
    if ([StringUtil isEmpty:url] || [StringUtil isEmpty:key]) {
        return nil;
    }
    NSString *value = nil;
    NSArray *components1 = [url componentsSeparatedByString:@"&"];
    for (NSString *oneComponent in components1) {
        NSArray *components2 = [oneComponent componentsSeparatedByString:@"="];
        if ([components2 count] == 2) {
            if ([key isEqualToString:[components2 objectAtIndex:0]]) {
                value = [components2 lastObject];
                break;
            }
        }
    }
    return value;
}

+ (NSString *)stringOfJsonFromDic:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }

    NSArray *dicKeys = [dic allKeys];
    if (!dicKeys || [dicKeys count] == 0) {
        return nil;
    }

    NSMutableString *resultString = [NSMutableString string];
    for (int i = 0; i < [dicKeys count]; i++) {
        id oneKey = [dicKeys objectAtIndex:i];
        if (!oneKey || ![oneKey isKindOfClass:[NSString class]]) {
            continue;
        }

        NSString *keyString = (NSString *) oneKey;
        id oneValue = [dic objectForKey:keyString];
        if (!oneValue || ![oneValue isKindOfClass:[NSString class]]) {
            continue;
        }
        NSString *valueString = (NSString *) oneValue;
        if (i == 0) {
            [resultString appendFormat:@"%@=%@", keyString, valueString];
        }
        else {
            [resultString appendFormat:@"&%@=%@", keyString, valueString];
        }

    }

    return resultString;
}


//获得含中英文混合字符串的长度
+ (NSInteger)getLength:(NSString *)complexString {
    if ([self isEmpty:complexString]) {
        return 0;
    }

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [complexString dataUsingEncoding:enc];
    NSInteger length = data.length;
    return length;
}

//获得含中英文混合字符串的长度
+ (NSInteger)getLength2:(NSString *)complexString {
    NSInteger length = 0;
    char *p = (char *) ([complexString cStringUsingEncoding:NSUnicodeStringEncoding]);
    for (int i = 0; i < [complexString lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            length++;
        }
        else {
            p++;
        }
    }
    return length;
}

+ (NSString *)getStringFromNumer:(NSNumber *)num {
    if (!num || ![num isKindOfClass:[NSNumber class]]) {
        return nil;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    return [formatter stringFromNumber:num];
}

+ (NSNumber *)getNumberFromString:(NSString *)string {
    if ([StringUtil isEmpty:string]) {
        return nil;
    }

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    return [formatter numberFromString:string];
}

+ (NSString *)trim:(NSString *)_content {
    return [_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (int)countCharacterNum:(NSString *)_content withCharCount:(int)unitCharCount {
    NSString *content = [self trim:_content];
    return (int) ceil((float) [self charCountOfString:content] / (float) unitCharCount);
}

+ (int)charCountOfString:(NSString *)content {
    int count = 0;
    for (int i = 0; i < [content length]; i++) {
        unichar c = [content characterAtIndex:i];
        if (isblank(c) || isascii(c)) {
            count++;
        } else {
            count += 2;
        }
    }
    return count;
}

+ (int)charCountOfString:(NSString *)content unitCharCount:(int)unitCharCount {
    int count = 0;
    for (int i = 0; i < [content length]; i++) {
        unichar c = [content characterAtIndex:i];
        if (isblank(c) || isascii(c)) {
            count++;
        } else {
            count += unitCharCount;
        }
    }
    return count;
}

/*
 *获取指定个数的字符串,length是字符长度
 *unitCharCount:字符的个数，中文：2
 */
+ (NSString *)subString:(NSString *)str length:(NSInteger)charIndex trail:(BOOL)trail unitCharCount:(int)unitCharCount {
    int count = 0;
    if (![StringUtil isStringWithAnyText:str]) {
        return nil;
    }
    NSString *subStr = str;
    for (int i = 0; i < [str length]; i++) {
        unichar c = [str characterAtIndex:(NSUInteger) i];
        if (isblank(c) || isascii(c)) {
            count++;
        } else {
            count += unitCharCount;
        }
        if (count >= charIndex) {
            if (trail) {
                subStr = [NSString stringWithFormat:@"%@...", [str substringToIndex:(NSUInteger) i]];
            } else {
                subStr = [str substringToIndex:(NSUInteger) i];
            }
            break;
        }
    }
    return subStr;
}

/*
 *获取指定个数的中文字符串,length是字符长度
 */
+ (NSString *)subString:(NSString *)str length:(NSInteger)charIndex trail:(BOOL)trail {
    return [self subString:str length:charIndex trail:trail unitCharCount:2];
}

/*
 *获取指定个数的字符串,length是字符长度,中文当1个
 */
+ (NSString *)subStringOnlyChar:(NSString *)str length:(NSInteger)charIndex trail:(BOOL)trail {
    return [self subString:str length:charIndex trail:trail unitCharCount:1];
}

//获得一个类的类名
+ (NSString *)className:(Class)aClass {
    const char *cName = object_getClassName(aClass);
    NSString *sName = [[NSString alloc] initWithBytesNoCopy:(char *) cName
                                                     length:strlen(cName)
                                                   encoding:NSASCIIStringEncoding
                                               freeWhenDone:NO];
    return sName;
}

//密码加密方法
+ (NSString *)encrypt:(NSString *)pwd {
    //先对密码进行md5加密
    NSString *md5Pwd = [pwd md5Hash];
    
    //再对密码进行sha1加密
    NSString *sha1Pwd = [md5Pwd sha1Hash];
    return sha1Pwd;
}

//城市名称，删除“市”
+ (NSString *)deleteCityNameSomeStr:(NSString *)str {
    NSString *resultStr = str;
    NSString *targetStr = [str substringFromIndex:[str length] - 1];
    if ([targetStr isEqualToString:@"市"]) {
        resultStr = [resultStr substringToIndex:([resultStr length] - 1)];
    }
    return resultStr;
}

@end
