//
//  SJNavAction.h
//
//
//  Created by Shaojie Hong on 15-1-29.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"
#import <UIKit/UIKit.h>


@interface SJNavAction : NSObject

+ (void)toRootVCWithTab:(SJTabState)tab andQuery:(NSDictionary *)quey;

+ (UIViewController *)pushVCWithName:(NSString*)name andQuery:(NSDictionary *)query;

+ (UIViewController *)presentVCWithName:(NSString *)name andQuery:(NSDictionary *)query;

+ (UIViewController *)pushVCWithName:(NSString*)name andQuery:(NSDictionary *)query andTab:(SJTabState)tab;

//用于返回UIViewController,前一个页面可以使用
+ (UIViewController *)pushVCWithName:(NSString *)name andQuery:(NSDictionary *)query animated:(BOOL)animated;


//获取当前屏幕显示的UIViewController
+ (UIViewController *)getCurrentViewController;

/*
 * 确保跳转时单独跳转，防止同时多项点击导致跳转错误
 */
+ (BOOL)ensureRedirectSingleFor:(Class)aClass;


@end
