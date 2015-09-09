//
//  SJTabBarController.h
//
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJTabBarController : UITabBarController<UITabBarControllerDelegate>

- (void)createRootViewControllers;

//tabBar的高度
+ (CGFloat)tabBarHeight;

@end
