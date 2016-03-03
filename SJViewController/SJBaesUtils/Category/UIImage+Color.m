//
//  UIImage+Color.m
//
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "UIImage+Color.h"
#import "SandboxFile.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (size.height == 0 || size.width == 0) {
//        NSLog(@"请检查size值,无法正确生成图片-%@", NSStringFromCGSize(size));
    }
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 * 从本地 资源文件 读取图片
 * @param name  文件名称 | 带后缀  @2x.png
 */
+ (UIImage*)imageWithContentsOfFileName:(NSString *)name{
    
    UIImage *image = [UIImage imageWithContentsOfFile:[SandboxFile GetPathForResource:name]];
    
    
    return image;
}


+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2 {
    CGSize size = rect1.size;
    
    UIGraphicsBeginImageContext(size);
    
    [image1 drawInRect:rect1];
    [image2 drawInRect:rect2];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


@end