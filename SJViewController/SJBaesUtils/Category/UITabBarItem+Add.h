//
//  UITabBarItem+Add.h
//
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

@interface UITabBarItem (Add)

/**
 *  为了同时适应iOS7及以下版本，自定义的创建方法
 *
 *  @param title         标题
 *  @param image         普通状态下图片
 *  @param selectedImage 选中时图片
 *  @param tag           标记
 *
 *  @return 返回已创建的UITabBarItem
 */
- (instancetype)initWithTitle:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage tag:(int)tag;

@end

