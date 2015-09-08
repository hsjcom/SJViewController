//
//  UINavigation+Spacing.m
//
//
//  Created by Soldier on 14-6-25.
//  Copyright (c) 2014年 Soldier. All rights reserved.
//

#import "UINavigation+Spacing.h"

@implementation UINavigationItem (Spacing)
/*
 * load 在初始化类时调用，每个类都有一个load 方法，
 * 类的初始化先于对象
 */
- (UIBarButtonItem *)spacer {
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    CGFloat width = Isios7() ? -20.f : -5.0f;
    space.width = width;

    return space;
}

/*
 * 控制导航栏按钮的位置
 */
- (void)setRightBarButtonItem:(UIBarButtonItem *)barButton {
    NSArray *barButtons = nil;
    barButtons = [NSArray arrayWithObjects:[self spacer], barButton, nil];
    [self setRightBarButtonItems:barButtons];
}

/*
 * 控制导航栏按钮的位置
 */
- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    NSArray *barButtons = nil;
    barButtons = [NSArray arrayWithObjects:[self spacer], leftBarButtonItem, nil];
    [self setLeftBarButtonItems:barButtons];
}

@end
