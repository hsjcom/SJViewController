//
//  NetworkUnit.h
//  zxwTool
//
//  Created by Shaojie Hong on 14-3-28.
//  Copyright (c) 2014年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NoErrorForDeleCartItem @"当前没有网络，请联网后再试"

////  网络类型

typedef NS_ENUM(NSInteger,NETWORK_TYPE) {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_2G= 2,
    NETWORK_TYPE_3G= 3,
    NETWORK_TYPE_4G= 4,
    NETWORK_TYPE_WIFI= 10,
};

@interface NetworkUnit : NSObject{
    
}

@property(nonatomic,assign) NETWORK_TYPE  networkType;

+ (id) sharedInstance;

+ (BOOL) isWifiNetWork;

/**
 * 网络情况为 3G 或3G以上
 */
+ (BOOL) is3GAbove;

+ (BOOL) is2GNetWork;

+ (BOOL) isNoNetWork;

/**
 * 非 wifi 且有网络
 */
+ (BOOL) isNetWorkNotWifi;

+ (NSString*) getNetworkTypeDescription;

+ (NETWORK_TYPE) getNetworkTypeFromStatusBar;

@end
