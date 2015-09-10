//
//  UserDefaultsUtils.m
//  
//
//  Created by Soldier on 12-6-19.
//  Copyright (c) 2012年 Shaojie Hong. All rights reserved.
//

#import "UserDefaultsUtils.h"

@implementation UserDefaultsUtils

+ (void)storeToUserDefault:(NSObject *)obj key:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:key];
    [userDefaults synchronize];
}

+ (void)storeToUserDefault:(NSDictionary *)dict {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in dict.allKeys) {
        NSObject *obj = [dict objectForKey:key];
        [userDefaults setObject:obj forKey:key];
    }
    [userDefaults synchronize];
}

+ (void)clear:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}

+ (id)getValue:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}


@end
