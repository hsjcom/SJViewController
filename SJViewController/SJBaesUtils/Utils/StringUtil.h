//
//  StringUtil.h
//  
//
//  Created by Soldier on 12-5-25.
//  Copyright (c) 2012年 Soldier. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    BOOL_TYPE,
    LONG_TYPE,
    DOUBLE_TYTP,
    FLOAT_TYTP,
    INT_TYTP,
} NumType;


@interface StringUtil : NSObject

+ (NSString *)urlEncode:(NSString *)str;

+ (NSString *)urlDecode:(NSString *)str;

+ (NSString *)trimWhitespace:(NSString *)str;

//去除所有空格，包括头尾，中间
+ (NSString *)trimAllWhitespace:(NSString *)str;

+ (NSString *)trimHTMLTag:(NSString *)str;


+ (NSString *)getStringForNotNull:(NSString *)inparam;

+ (NSString *)getString:(NSDictionary *)dict key:(NSString *)key;

+ (NSString *)getStringForNull:(NSDictionary *)dict key:(NSString *)key;

+ (NSString *)getStringForType:(NumType)numType dic:(NSDictionary *)dict key:(NSString *)key;

+ (NSNumber *)getNumberFromString:(NSDictionary *)dict key:(NSString *)key;

+ (NSNumber *)getNumberForType:(NumType)numType  dic:(NSDictionary *)dict key:(NSString *)key;

+ (BOOL)isStringWithAnyText:(id)object;

+ (BOOL)isEmpty:(NSString *)str;

+ (BOOL)isTelIegal:(NSString *)tel;

+ (BOOL)isPriceIegal:(NSString *)price;

+ (BOOL)isEmailLegal:(NSString *)email;

+ (BOOL)isNickLegal:(NSString *)nick;

//中文数字_ && 非纯数字 && 不包含“@”
+ (BOOL)isNickLegal2:(NSString *)str;

+ (BOOL)isNumber:(NSString *)str;

+ (BOOL)isPhoneNumber:(NSString *)str;

+ (BOOL)isMobileNumber:(NSString *)str;

+ (BOOL)isHyperLink:(NSString *)URL;

+ (BOOL)hasChar:(NSString *)str;

+ (NSDictionary *)dictFromReqParam:(NSString *)string;

+ (NSString *)stringOfJsonFromDic:(NSDictionary *)dic;

+ (NSString *)replaceNewlineAndBreak:(NSString *)str;

+ (NSString *)encodeNewLineAndBreak:(NSString *)str;

+ (NSString *)getParamFromJsonURL:(NSString *)url andParamKey:(NSString *)string;

//获得含中英文混合字符串的长度
+ (NSInteger)getLength:(NSString *)complexString;

//获得含中英文混合字符串的长度
+ (NSInteger)getLength2:(NSString *)complexString;

+ (NSString *)getStringFromNumer:(NSNumber *)num;

+ (NSNumber *)getNumberFromString:(NSString *)string;


+ (NSString *)trim:(NSString *)content;

+ (int)countCharacterNum:(NSString *)content withCharCount:(int)unitCharCount;

+ (int)charCountOfString:(NSString *)content;

+ (int)charCountOfString:(NSString *)content unitCharCount:(int)unitCharCount;

+ (NSString *)subString:(NSString *)str length:(NSInteger)charIndex trail:(BOOL)trail;

+ (NSString *)subStringOnlyChar:(NSString *)str length:(NSInteger)charIndex trail:(BOOL)trail;

//获得一个类的类名
+ (NSString *)className:(Class)aClass;

//密码加密方法
+ (NSString *)encrypt:(NSString *)pwd;

//城市名称，删除“市”
+ (NSString *)deleteCityNameSomeStr:(NSString *)str;

@end
