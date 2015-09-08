//
//  SJHTTPRequset.h
//
//
//  Created by Soldier on 15/9/6.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "ASIFormDataRequest.h"


@interface SJHTTPRequest : ASIFormDataRequest

/**
 * get方式 初始化
 */
- (SJHTTPRequest *)initWithURL:(NSString *)_url andDelegate:(id)_delegate;

/**
 * post方式 初始化
 */
- (SJHTTPRequest *)initWithPostURL:(NSString *)_url andDelegate:(id)_delegate;

/**
 * 设置缓存时间
 * @param seconds 秒数
 */
- (void)setCacheTime:(NSUInteger)seconds;

/**
 * 添加 post 字段信息 用字典模式  若字段少也可不用字典 直接 addPostValue for key
 */
- (void)addPostValueForDic:(NSDictionary *)_dic;

/**
 * 添加 post 字段信息 直接 addPostValue for key
 */
- (void)addPostSafeValue:(id <NSObject>)value forKey:(NSString *)key;

/**
 * 添加 成功和失败 回调方法  @select
 */
- (void)addSelectFinish:(SEL)finishSelector andDidFailSelector:(SEL)failSelector;

//同步请求
- (void)sendSynchronousRequest;

/**
 * 发送请求
 */
- (void)sendRequest;

/**
 * 清除 本地http 缓存文件
 */
+ (void)clearCacheStorageFile;

/**
 * 通过 url 取缓存 前提用得默认缓存机制
 * @param _url string
 */
+ (NSDictionary *)cacheResponeWithURL:(NSString *)_url;

/**
 * 判断缓存是否过期
 */
- (BOOL)canUseCachedData;

/**
 * 根据是否手动强制更新，设置不同缓存读取策略
 */
- (void)setManualCachePolicy:(BOOL)isManual;

@end


