//
//  SJNavAction.m
//
//
//  Created by Shaojie Hong on 15-1-29.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJNavAction.h"
#import "SJViewController.h"

@implementation SJNavAction


+ (void)toRootVCWithTab:(SJTabState)tab andQuery:(NSDictionary *)quey{
    /*
    AppDelegate *app = (AppDelegate *)AppDelegateInstance;
    app.tabBarController.selectedIndex = tab;
    
    UINavigationController *nav = nil;
    if (tab == Tab_Mall) {
        nav = app.tabBarController.mall.navigationController;
    }else if (tab == Tab_Category){
        nav = app.tabBarController.category.navigationController;
    }else if (tab == Tab_ShopCart){
        nav = app.tabBarController.shopCart.navigationController;
    }else if (tab == Tab_Fourm){
        nav = app.tabBarController.forum.navigationController;
    }else if (tab == Tab_Mine){
        nav = app.tabBarController.mine.navigationController;
    }
    
    if (nav.viewControllers.count > 1) {
        [nav popToRootViewControllerAnimated:YES];
    }
    */
}

+ (UIViewController *)pushVCWithName:(NSString *)name andQuery:(NSDictionary *)query{
    return [SJNavAction pushVCWithName:name andQuery:query animated:YES];
}

//用于返回UIViewController,前一个页面可以使用
+ (UIViewController *)pushVCWithName:(NSString *)name andQuery:(NSDictionary *)query animated:(BOOL)animated {
    // 参数 判断 String +
    UIViewController *topController = [SJNavAction getCurrentViewController];
    SJViewController *controller = [[NSClassFromString(name) alloc] initWithQuery:query];
    if (controller) {
        controller.hidesBottomBarWhenPushed = YES;
        if (query) {
            controller.query = query;
        }
        
        if ([controller backButtonTilte]) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[controller backButtonTilte] style:UIBarButtonItemStylePlain target:nil action:nil];
            topController.navigationItem.backBarButtonItem = item;
        }
        else{
//            NSString *className = [StringUtil className:topController.class];
        }
        
        [topController.navigationController pushViewController:controller animated:animated];
        return controller;
        
    } else {
        return nil;
    }
}

+ (UIViewController *)pushVCWithName:(NSString *)name andQuery:(NSDictionary *)query andTab:(SJTabState)tab {
    
    AppDelegate *app = (AppDelegate *)AppDelegateInstance;
    app.tabBarController.selectedIndex = tab;
    
    return  [SJNavAction pushVCWithName:name andQuery:query];
}

+ (UIViewController *)presentVCWithName:(NSString *)name andQuery:(NSDictionary *)query {
    
    UIViewController *topController = [SJNavAction getCurrentViewController];
    
    SJViewController *controller = [[NSClassFromString(name) alloc] initWithQuery:query];
    if (controller) {
        controller.hidesBottomBarWhenPushed = YES;
        if ([controller backButtonTilte]) {
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[controller backButtonTilte] style:UIBarButtonItemStylePlain target:nil action:nil];
            topController.navigationItem.backBarButtonItem = item;
        }
        
        UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:controller];
        [topController.navigationController presentViewController:navVC animated:YES completion:^{}];
        return controller;
    } else {
        return nil;
    }
}

/**
 * 获取当前屏幕显示的UIViewController
 * by Soldier
 */
+ (UIViewController *)getCurrentViewController {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    /*
     *
     */
    if ([result isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)result;
        if ([tabBarController.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController *)tabBarController.selectedViewController;
            result = navigationController.topViewController;
        }
    } else if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)result;
        result = navigationController.topViewController;
    }
    return result;
}

/*
 * 确保跳转时单独跳转，防止同时多项点击导致跳转错误
 */
+ (BOOL)ensureRedirectSingleFor:(Class)aClass{
    UIViewController *topController = [SJNavAction getCurrentViewController];
    if (![topController isKindOfClass:aClass]) {//防止同时点击，进而页面跳转出错
        return NO;
    }
    
    return  YES;
}

        

@end
