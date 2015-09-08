//
//  UITabBarItem+Add.m
//
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "UITabBarItem+Add.h"

@implementation UITabBarItem (Add)

- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage tag:(int)tag
{
    UITabBarItem *item = nil;
    if (IsiOS7()) {
        // 采用 原图 不让其处理
        item = [self initWithTitle:title image:[UIImage imageNamed:image] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        item.tag = tag;
    } else {
        item = [self initWithTitle:title image:[UIImage imageNamed:image] tag:tag];
        [item setFinishedSelectedImage:[UIImage imageNamed:selectedImage] withFinishedUnselectedImage:[UIImage imageNamed:image]];
        
    }
    
    if (!IsiPad()) {
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
//        item.imageInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    }
    
    return item;
}

@end