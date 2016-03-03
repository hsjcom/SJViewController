//
//  ImageUtil.h
//  
//
//  Created by Shaojie Hong on 13-9-10.
//  Copyright (c) 2013年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ImageRoundCorner) {
    ImageRoundCorner_None = 0,
    ImageRoundCorner_TopRight = 1 << 0,
    ImageRoundCorner_BottomRight = 1 << 1,
    ImageRoundCorner_BottomLetf = 1 << 2,
    ImageRoundCorner_TopLeft = 1 << 3,
};

static NSUInteger ImageRoundCornerALL = ImageRoundCorner_TopRight | ImageRoundCorner_BottomRight | ImageRoundCorner_BottomLetf | ImageRoundCorner_TopLeft;

@interface ImageUtil : NSObject {

}
//缩小所用
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

//保证image缩放为对应大小
+ (UIImage *)zoomToSize:(UIImage *)image size:(CGSize)drawSize;

+ (NSString *)dataEncodeImgToUpload:(UIImage *)img;

/* 根据UIColor获得UIIImage*/
+ (UIImage *)createImageWithColor:(UIColor *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color
                        withFrame:(CGRect)rect
                  andCornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)createImageWithColor:(UIColor *)color
                        withFrame:(CGRect)rect
                  andCornerRadius:(CGFloat)cornerRadius
              andImageRoundCorner:(ImageRoundCorner)imageRoundCorner;

/* blur the current image with a box blur algoritm */
+ (UIImage *)blurryImage:(UIImage *)originalImg withBlurLevel:(CGFloat)blur;

//截取部分图像
+ (UIImage *)getSubImage:(UIImage *)image size:(CGSize)size;

+ (void)circleImgAction:(UIImageView *)view;
/*
 * 图片加水印
 */
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage;

+ (UIImage *)imageName:(NSString *)imageName;

+ (UIImage *)imageNameIPad:(NSString *)imageName;


@end
