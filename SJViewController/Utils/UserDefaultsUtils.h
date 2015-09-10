//
//  UserDefaultsUtils.h
//
//
//  Created by Soldier on 12-6-19.
//  Copyright (c) 2012年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsUtils : NSObject

+ (void)storeToUserDefault:(NSObject *)obj key:(NSString *)key;

+ (void)storeToUserDefault:(NSDictionary *)dict;

+ (id)getValue:(NSString *)key;

+ (void)clear:(NSString *)key;


@end
