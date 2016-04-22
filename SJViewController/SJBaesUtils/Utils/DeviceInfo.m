//
//  DeviceInfo.m
// 
//
//  Created by Shaojie Hong on 15-2-2.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "DeviceInfo.h"
#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>
#import <AdSupport/ASIdentifierManager.h>
#import "OpenUDID.h"

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define REALUDID @"realUDID"
#define IOSIDFA @"IosIDFA"

@implementation DeviceInfo

/**
 * 返回 不带 . 的版本号
 * eg:return 645
 */
+ (NSString *)appVersionIntString{
    NSString *av = [Bunndle_AppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    return av;
}

/**
 * 设备 系统版本号 e.g.  8.0.3
 */
+ (NSString *)deviceSysVersion {
    NSString *osVersion =  [UIDevice currentDevice].systemVersion;
    return osVersion;
}

+ (NSString *)macString {
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *) buf;
    sdl = (struct sockaddr_dl *) (ifm + 1);
    ptr = (unsigned char *) LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3), *(ptr + 4), *(ptr + 5)];
    free(buf);
    
    return macString;
}

/**
 *  me:EFF8E040-A579-4A2C-B954-58B382CDE4D6
 */
+ (NSString *)idfaString {
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    } else {
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        if (asIdentifierMClass == nil) {
            return @"";
        } else {
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            if (asIM == nil) {
                return @"";
            } else {
                if (asIM.advertisingTrackingEnabled) {
                    return [asIM.advertisingIdentifier UUIDString];
                } else {
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

+ (NSString *)idfvString {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return @"";
}

/**
 *
 * @return 设备唯一标识符 对应字段：token
 */
+ (NSString *)realUDID {
    NSString *udid = nil;
    udid  = [UserDefaultsUtils getValue:IOSIDFA];
    if (udid) {
        return udid;
    }
    udid = [DeviceInfo idfaString];
    if ([@"" isEqualToString:udid]) {
        udid =  [[OpenUDID value] md5Hash] ;
    } else {
        [UserDefaultsUtils storeToUserDefault:udid key:IOSIDFA];
    }
    
    if (udid == nil || udid.length == 0) {
        udid = @"cannot get  IDFA and OpenUDID";
    }
    return udid;
}

/**
 * @"iPhone", @"iPad"
 * @return iPhone
 */
+ (NSString *)deviceModelString {
    UIDevice *device = [UIDevice currentDevice];
    NSString *pattenName = device.model;
    
    return pattenName;
}

/**
 * 系统内核 版本号 iPhone6.2 对应 5s  可区分机器型号
 * @return iPhone6.2
 */
+ (NSString *)deviceMachineString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return machine;
}

+ (NSString *)deviceWidth {
    NSString *wt = [NSString stringWithFormat:@"%.0f", UI_SCREEN_WIDTH];
    return wt;
}

+ (NSString *)deviceHeight {
    NSString *wt = [NSString stringWithFormat:@"%.0f", UI_SCREEN_HEIGHT];
    return wt;
}

+ (BOOL)isPhoneSupported{
    NSString *deviceType = [UIDevice currentDevice].model;
    return [@"iPhone" isEqualToString:deviceType];
}

+ (NSString *)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

@end