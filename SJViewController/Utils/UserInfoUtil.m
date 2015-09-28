//
//  UserInfoUtil.m
//
//
//  Created by Soldier on 15/2/9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "UserInfoUtil.h"
#import "UserDefaultsUtils.h"

@implementation UserInfoUtil

#define USER_INFO           @"user_info"

#define NICKNAME            @"nickname"
#define ACCOUNT_ID          @"account_id"
#define TICKET_ID           @"ticket_id"   
#define USERNAME            @"username"
#define SEXTYPE             @"sexType"
#define MOBILE              @"mobile"

#define CONSIGNEE           @"consignee"  //收货人
#define LOCATE              @"locate"     //省市区
#define ADDRESS             @"address"    //详细地址
#define BASEADDR            @"baseAddr"   //所在地（省市）

#pragma mark - Store

/*
 * 存储账号
 */
+ (void)storeUserName:(NSString *)userName{
    [self store:userName key:USERNAME];
}

/*
 * 存储昵称
*/
+ (void)storeNickname:(NSString *)nick {
    if (![StringUtil isEmpty:nick]) {
        [self store:nick key:NICKNAME];
    }
}

/*
 * 存储accountID
 */
+ (void)storeAccountID:(NSString *)accountID {
    [self store:accountID key:ACCOUNT_ID];
}

/*
 * 存储ticketID
 */
+ (void)storeTicketId:(NSString *)ticketId {
    [self store:ticketId key:TICKET_ID];
}

/*
 * 存储性别
 */
+ (void)storeSexType:(NSString *)sexType {
    [self store:sexType key:SEXTYPE];
}

/*
 * 存储所在地(字典)
 */
+ (void)storeBaseAddr:(NSDictionary *)baseAddr {
    [self store:baseAddr key:BASEADDR];
}

/*
 * 存储收货人名字
 */
+ (void)storeConsignee:(NSString *)consignee {
    [self store:consignee key:CONSIGNEE];
}

/*
 * 存储收货人省市区
 */
+ (void)storeLocate:(NSDictionary *)locate {
    [self store:locate key:LOCATE];
}

/*
 * 存储收货人详细地址
 */
+ (void)storeAddress:(NSString *)address {
    [self store:address key:ADDRESS];
}

+ (void)storeMobile:(NSString *)mobile {
    [self store:mobile key:MOBILE];
}


#pragma mark - Get  

/*
 * 获取对应key的值
 */
+ (id)getValue:(NSString *)key {
    NSDictionary *dict = [UserDefaultsUtils getValue:USER_INFO];
    return [dict objectForKey:key];
}

/*
 * 获取帐号名
 */
+ (NSString *)getUsername {
    return [self getValue:USERNAME];
}

/*
 * 获取昵称
 */
+ (NSString *)getNickname {
    return [self getValue:NICKNAME];
}

/*
 * 获取TicketId
 */
+ (NSString *)getTicketId {
    NSString *ticketId = [self getValue:TICKET_ID];
    return ![StringUtil isEmpty:ticketId] ? ticketId : @"";
}

/*
 * 获取AccountId
 */
+ (NSString *)getAccountId {
    NSString *accountId = [self getValue:ACCOUNT_ID];
    return ![StringUtil isEmpty:accountId] ? accountId : @"";
}

/*
 * 获取性别
 */
+ (NSString *)getSexType {
    return [self getValue:SEXTYPE];
}

/*
 * 获取所在地
 */
+ (NSDictionary *)getBaseaddr {
    return [self getValue:BASEADDR];
}

/*
 * 获取收货人
 */
+ (NSString *)getConsignee {
    return [self getValue:CONSIGNEE];
}

/*
 * 获取省市区信息
 */
+ (NSDictionary *)getLocate {
    return [self getValue:LOCATE];
}

/*
 * 获取收货人详细信息
 */
+ (NSString *)getAddress {
    return [self getValue:ADDRESS];
}

+ (NSString *)getMobile {
    return [self getValue:MOBILE];
}

#pragma mark - Fun

/*
 * 存储方法
 */
+ (void)store:(id)value key:(NSString *)key {
    if ([StringUtil isEmpty:key]) {
        return;
    }
    
    NSMutableDictionary *persistInfo = [UserDefaultsUtils getValue:USER_INFO];
    if (persistInfo) {
        persistInfo = [NSMutableDictionary dictionaryWithDictionary:persistInfo];
    }
    else{
        persistInfo = [NSMutableDictionary dictionary];
    }
    
    [NSDictionary setDict:persistInfo value:value forKey:key];
    [UserDefaultsUtils storeToUserDefault:persistInfo key:USER_INFO];
}

/*
 * 存储字典，带有多组数据
 */
+ (void)storeDic:(NSMutableDictionary *)dic {
    NSMutableDictionary *persistInfo = [UserDefaultsUtils getValue:USER_INFO];
    if (persistInfo) {
        persistInfo = [NSMutableDictionary dictionaryWithDictionary:persistInfo];
    }
    else{
        persistInfo = [NSMutableDictionary dictionary];
    }
    [persistInfo addEntriesFromDictionary:dic];
    [UserDefaultsUtils storeToUserDefault:persistInfo key:USER_INFO];
}

/*
 * 清除keys对应的数据
 */
+ (void)clearKeys:(NSArray *)keys {
    NSMutableDictionary *persistInfo = [UserDefaultsUtils getValue:USER_INFO];
    if (persistInfo) {
        persistInfo = [NSMutableDictionary dictionaryWithDictionary:persistInfo];
        [persistInfo removeObjectsForKeys:keys];
        [UserDefaultsUtils storeToUserDefault:persistInfo key:USER_INFO];
    }
}

/*
 * 清除账号的相关地址信息
 */
+ (void)clearAccountLocationInfo {
    NSArray *keys = [NSArray arrayWithObjects:CONSIGNEE, LOCATE, ADDRESS, nil];
    [self clearKeys:keys];
}

/*
 * 清除账号的相关信息
 */
+ (void)clearAccountInfo {
    NSArray *keys = [NSArray arrayWithObjects:NICKNAME, TICKET_ID, ACCOUNT_ID, nil];
    
    [self clearKeys:keys];
}



@end