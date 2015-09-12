//
//  SJHTTPRequset.m
//
//
//  Created by Soldier on 15/9/6.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "NSString+SJ.h"
#import "JSONKit.h"


@implementation SJHTTPRequest

/**
 * get方式 初始化
 */
- (SJHTTPRequest *)initWithURL:(NSString *)_url andDelegate:(id)_delegate {
    if ([NSString isEmpty:_url]) {
//        NSLog(@"_url = empty  !!!");
        return nil;
    }
    
    self = [self initWithURL:[NSURL URLWithString:_url]];

    [self setDelegate:_delegate];

     // 设置超时 N 次 重试
    [self setNumberOfTimesToRetryOnTimeout: 0];
    
    [self addCommonHeadInfo];
    
    return self;
}

/**
 * post方式 初始化
 */
- (SJHTTPRequest *)initWithPostURL:(NSString *)_url andDelegate:(id)_delegate {
    self = [self initWithURL:_url andDelegate:_delegate];
    
    [self setShouldAttemptPersistentConnection:NO];
    [self setRequestMethod:@"POST"];
    
    return self;
}

/**
 * 设置缓存时间
 * @param seconds 秒数
 */
- (void)setCacheTime:(NSUInteger)seconds{
    if (seconds == 0) {
        return;
    }
    
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [self setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [self setDownloadCache:[ASIDownloadCache sharedCache]];
    
    [self setSecondsToCache: seconds];
    // 使用 get 方式才会缓存
}


/**
 * 清除 本地http 缓存文件
 */
+ (void)clearCacheStorageFile{
    [[ASIDownloadCache sharedCache] clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}

/**
 * 通过 url 取缓存 前提用得默认缓存机制
 * @param _url string
 */
+ (NSDictionary *)cacheResponeWithURL:(NSString *)_url{
    NSData *data = [[ASIDownloadCache sharedCache] cachedResponseDataForURL:[NSURL URLWithString:_url]];
    if (data){
        NSString *respone = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
        NSDictionary *jsonDict = [respone objectFromJSONString];
        return jsonDict;
    }
    
    return nil;
}

/**
 * 判断缓存是否过期
 */
- (BOOL)canUseCachedData{
    BOOL flag = NO;
    
    if (![self downloadCache]) {
        [self setDownloadCache:[ASIDownloadCache sharedCache]];
    }
    
    [self setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    flag = [[self downloadCache] canUseCachedDataForRequest:self];
    return flag;
}

/**
 * 添加 公共头信息
 */
- (void)addCommonHeadInfo{
//    [self addRequestHeader:@"PL" value:(Isipad() ? @"ipad" : @"iphone")];
}

/**
 * 添加 成功和失败 回调方法  @select
 */
- (void)addSelectFinish:(SEL)finishSelector andDidFailSelector:(SEL)failSelector{
    if (!delegate) {
//        NSLog(@"Http request delegate is null");
    }
    
    if (finishSelector && delegate) {
        [self setDidFinishSelector:finishSelector];
    }
    
    if (failSelector && delegate) {
        [self setDidFailSelector:failSelector];
    }
}

/**
 * 添加 post 字段信息 用字典模式  若字段少也可不用字典 直接 addPostValue for key
 */
- (void)addPostValueForDic:(NSDictionary *)_dic {
    
    [self setRequestMethod:@"POST"];
    
    for (NSString *key in _dic.allKeys){
        NSString *value = [_dic objectForKey:key];
        [self addPostValue:value forKey:key];
    }
}

- (void)addPostSafeValue:(id <NSObject>)value forKey:(NSString *)key{
    if (!value || !key) {
//        NSLog(@"post key or value  Invalid~~~~,key:%@  value :%@",key,value);
        return;
    }
    
    [self addPostValue:value forKey:key];
}

/**
 * 同步请求
 */
- (void)sendSynchronousRequest{
    self.startTime = [[NSDate date] timeIntervalSince1970];
    [self startSynchronous];
}

- (void)sendRequest{
    self.startTime = [[NSDate date] timeIntervalSince1970];
    [self startAsynchronous];
}

/**
 * 根据是否手动强制更新，设置不同缓存读取策略
 */
- (void)setManualCachePolicy:(BOOL)isManual{
    if (isManual) {
        [self setCachePolicy:ASIDoNotReadFromCacheCachePolicy];
    }
    else{
        [self setCachePolicy:ASIUseDefaultCachePolicy];
    }
}

@end


