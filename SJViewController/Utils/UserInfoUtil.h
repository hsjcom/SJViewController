//
//  UserInfoUtil.h
//
//
//  Created by Soldier on 15/2/9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//



@interface UserInfoUtil : NSObject

#pragma mark - Store

/*
 * 存储accountID
 */
+ (void)storeAccountID:(NSString *)accountID;

/*
 * 存储ticketID
 */
+ (void)storeTicketId:(NSString *)ticketId;

/*
 * 存储账号
 */
+ (void)storeUserName:(NSString *)userName;

/*
 * 存储昵称
 */
+ (void)storeNickname:(NSString *)nick;

/*
 * 存储性别
 */
+ (void)storeSexType:(NSString *)sexType;

/*
 * 存储所在地字典
 */
+ (void)storeBaseAddr:(NSDictionary *)baseAddr;

/*
 * 存储收货人名字
 */
+ (void)storeConsignee:(NSString *)consignee;

/*
 * 存储收货人省市区
 */
+ (void)storeLocate:(NSDictionary *)locate;

/*
 * 存储收货人详细地址
 */
+ (void)storeAddress:(NSString *)address;

/*
 * 存储手机
 */
+ (void)storeMobile:(NSString *)mobile;



#pragma mark - Get

/*
 * 获取账户名
 */
+ (NSString *)getUsername;

/*
 * 获取昵称
 */
+ (NSString *)getNickname;

/*
 * 获取TicketId
 */
+ (NSString *)getTicketId;

/*
 * 获取AccountId
 */
+ (NSString *)getAccountId;

/*
 * 获取性别
 */
+ (NSString *)getSexType;

/*
 * 获取所在地
 */
+ (NSDictionary *)getBaseaddr;

/*
 * 获取收件人
 */
+ (NSString *)getConsignee;

/*
 * 获取省市区信息
 */
+ (NSDictionary *)getLocate;

/*
 * 获取收货人详细信息
 */
+ (NSString *)getAddress;

+ (NSString *)getMobile;




#pragma mark -  Fun

/*
 * 存储方法
 */
+ (void)store:(id)value key:(NSString *)key;

/*
 * 存储字典，带有多组数据
 */
+ (void)storeDic:(NSMutableDictionary *)dic;

/*
 * 获取对应key的值
 */
+ (id)getValue:(NSString *)key;

/*
 * 清除keys对应的数据
 */
+ (void)clearKeys:(NSArray *)keys;

/*
 * 清除账号的相关地址信息
 */
+ (void)clearAccountLocationInfo;

/*
 * 清除账号的相关信息
 */
+ (void)clearAccountInfo;

@end