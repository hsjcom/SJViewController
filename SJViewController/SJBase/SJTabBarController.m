//
//  SJTabBarController.m
//
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJTabBarController.h"
#import "SJNavigationController.h"
#import "UITabBarItem+Add.h"
#import "UIImage+Color.h"
#import "SJNavAction.h"
#import "SJTableViewController.h"

@interface SJTabBarController ()

@end




@implementation SJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
 
    //设置  UITabBar  UINavigationBar   UIBarButtonItem 样式
    [self setNavigationBarAndTabBarStyle];
}

-(void)createRootViewControllers{
    /*
    self.mall = [[MallViewController alloc]initWithQuery:nil];
    self.category = [[CategoryViewController alloc]initWithQuery:nil];
    self.shopCart = [[ShopCartViewController alloc]initWithQuery:nil];
    self.forum = [[ForumCoverViewController alloc]initWithQuery:nil];
    self.mine = [[MineViewController alloc]initWithQuery:nil];
    
    
    SJNavigationController *navMall = [[SJNavigationController alloc]initWithRootViewController:self.mall];
    SJNavigationController *navCategory = [[SJNavigationController alloc]initWithRootViewController:self.category];
    SJNavigationController *navShopCart = [[SJNavigationController alloc]initWithRootViewController:self.shopCart];
    SJNavigationController *navForum = [[SJNavigationController alloc]initWithRootViewController:self.forum];
    SJNavigationController *navMine = [[SJNavigationController alloc]initWithRootViewController:self.mine];
 

    navMall.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"商城"   image:@"tab0"selectedImage:@"tab0_up" tag:Tab_Mall];
    navCategory.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"分类"   image:@"tab1"selectedImage:@"tab1_up" tag:Tab_Category];
    navForum.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"社区"   image:@"tab2"selectedImage:@"tab2_up" tag:Tab_Fourm];
    navShopCart.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"购物车" image:@"tab3"selectedImage:@"tab3_up" tag:Tab_ShopCart];
    navMine.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我"     image:@"tab4"selectedImage:@"tab4_up" tag:Tab_Mine];
    
    [self setViewControllers:@[navMall,navCategory,navForum,navShopCart,navMine]];
     */
}

/**
 * 设置  UITabBar    UINavigationBar   UIBarButtonItem 样式
 */
- (void)setNavigationBarAndTabBarStyle{
    //设置 底部 tabBar  tabBarItem 按钮 颜色 字体 按下效果 等
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:COLOR_NAVBAR_BG]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_TEXT_2} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_TEXT_1} forState:UIControlStateSelected];
    
    //设置 barButton 按钮 颜色 字体 按下效果 等
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
    if(IsiOS7()){
        [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_TEXT_1} forState:UIControlStateNormal];
        [barButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName: COLOR_TEXT_2} forState:UIControlStateHighlighted];
    }
    
    //去除iOS6  底部选择灰框
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
    
    //设置 UINavigationBar 顶部标题 字体颜色 大小
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                    COLOR_TEXT_1, NSForegroundColorAttributeName,
                                    shadow, NSShadowAttributeName,
                                    [UIFont systemFontOfSize:17],
                                    NSFontAttributeName,
                                    nil]];
    
    //设置返回键 按钮 箭头《 nav 背景颜色
    
//    //获取Navigation Bar的位置和大小
//    CGSize titleSize = navBar.bounds.size;
//    UIImage *bgImage = [UIImage imageWithColor:RGBCOLOR(255, 255, 255) size:titleSize];
//    [navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];  //设置背景
    
    if(IsiOS7()){
        [navBar setBarTintColor:COLOR_NAVBAR_BG];
    
//        UIImage *backIndicatorImg = [[UIImage imageNamed:@"navBackIndicatorImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [navBar setBackIndicatorImage:backIndicatorImg];
//        [navBar setBackIndicatorTransitionMaskImage:backIndicatorImg];
//        [barButtonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-3, 2) forBarMetrics:UIBarMetricsDefault];
    }else{
        [navBar setTintColor:COLOR_NAVBAR_BG];
    }
    
    // 去除nav  top 下面那条黑线 取消
    [navBar setShadowImage:[[UIImage alloc] init]];
    
    // 黑色时间栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置 window 的背景色 防止影响 nav 背景色
    if (IsiOS7()) {
        SJ_Keywindow.backgroundColor = RGBCOLOR(255, 255, 255);
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UIViewController *tbSelectedController = (UIViewController *)tabBarController.selectedViewController;
    
    static BOOL doubleTab = NO;
    if ([tbSelectedController isEqual:viewController]) {
        doubleTab = !doubleTab;
        if (doubleTab) {
            UINavigationController *navigationController = (UINavigationController *)viewController;
            SJTableViewController *oneController = (SJTableViewController *)navigationController.topViewController;
            if ([oneController respondsToSelector:@selector(refreshControll)] && oneController.refreshControll.pullDownRefreshing) {
                return NO;
            }
            [oneController tabClickrefreshData];
        }
        
        return NO;
    }
    
    doubleTab = !doubleTab;
    
    return YES;
}

//tabBar的高度
+ (CGFloat)tabBarHeight{
    AppDelegate *app = (AppDelegate *)AppDelegateInstance;
    UITabBar *tabBar = app.tabBarController.tabBar;
    CGFloat height = tabBar.height;
    return height;
}



@end




