//
//  UIImage+Color.h
//  
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

@interface UIImage (Color)

/**
 *  根据颜色创建一个纯色图片
 *
 *  @param color 生成纯色图片的颜色
 *
 *  @return 根据传入颜色和尺寸生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据颜色创建一个纯色图片
 *
 *  @param color 生成纯色图片的颜色
 *  @param size  生成纯色图片的大小
 *
 *  @return 根据传入颜色和尺寸生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 * 从本地 资源文件 读取图片
 * @param name  文件名称 | 带后缀
 */
+ (UIImage*)imageWithContentsOfFileName:(NSString *)name;

/**
 *  两张图片合成一张
 *
 *  @param image1 生成纯色图片的颜色
 *  @param image2  生成纯色图片的大小
 *
 *  @return 根据传入颜色和尺寸生成的图片
 */

+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2;



@end

