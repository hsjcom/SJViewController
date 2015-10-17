//
//  DeviceInfo.h
//
//
//  Created by Shaojie Hong on 15-2-2.
//  Copyright (c) Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaultsUtils.h"


@interface DeviceInfo : NSObject

+ (NSString *)realUDID;

+ (NSString *)macString;

+ (NSString *)idfaString;

+ (NSString *)idfvString;

+ (NSString *)deviceSysVersion;

+ (NSString *)appVersionIntString;

+ (NSString *)deviceModelString;

+ (NSString *)deviceMachineString;

+ (NSString *)deviceWidth;

+ (NSString *)deviceHeight;

+ (BOOL)isPhoneSupported;

+ (NSString *)getCurrentLanguage;

@end
