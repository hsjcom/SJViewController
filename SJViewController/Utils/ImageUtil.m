//
//  ImageUtil.m
//  
//
//  Created by Shaojie Hong on 13-9-10.
//  Copyright (c) 2013年 Shaojie Hong. All rights reserved.
//

#import "ImageUtil.h"
#import <Accelerate/Accelerate.h>
#import "NSData+SJ.h"
#import "NetworkUnit.h"

@implementation ImageUtil

//缩小所用
+ (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size {
    BOOL isHorizontal = image.size.width >= image.size.height;
    CGFloat width = 0, height = 0;
    if (isHorizontal) {
        height = image.size.height <= size.height ? image.size.height : size.height;
        width = floorf(height * image.size.width / image.size.height);
    }
    else {
        width = image.size.width <= size.width ? image.size.width : size.width;
        height = floorf(width * image.size.height / image.size.width);
    }
    

    CGSize drawSize = CGSizeMake(width, height);
    return [self zoomToSize:image size:drawSize];

}

//保证image缩放为对应大小
+ (UIImage *)zoomToSize:(UIImage *)image size:(CGSize)drawSize{
    if (CGSizeEqualToSize(image.size, drawSize)) {
        return image;
    }

    CGFloat width = drawSize.width;
    CGFloat height = drawSize.height;
    UIImage *scaledImage = nil;
    @autoreleasepool {
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContextWithOptions(drawSize, NO, image.scale);
        // 绘制改变大小的图片
        [image drawInRect:CGRectMake(0, 0, width, height)];
        // 从当前context中创建一个改变大小后的图片
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
    }
    
    // 返回新的改变大小后的图片
    return scaledImage;
    
}


//截取部分图像
+ (UIImage *)getSubImage:(UIImage *)image size:(CGSize)size {
    CGFloat scale = 1.0;
    CGFloat toRatio = size.width / size.height;
    CGFloat originalRatio = image.size.width / image.size.height;
    BOOL flag;
    if (toRatio <= originalRatio) {
        scale = image.size.height / size.height;
        flag = YES;
    }
    else {
        scale = image.size.width / size.width;
        flag = NO;
    }

    // 按区域大小截取图片
    CGRect rect = CGRectZero;
    if (flag) {
        CGFloat scaleWidth = size.width * image.size.height / size.height;
        rect = CGRectMake(floorf((image.size.width - scaleWidth) / 2), 0, scaleWidth, image.size.height);
    }
    else {
        CGFloat scaleHeight = size.height * image.size.width / size.width;
        rect = CGRectMake(0, floorf((image.size.height - scaleHeight) / 2), image.size.width, scaleHeight);
    }

    CGImageRef imgageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imgageRef, rect);
    UIImage *scaledImage = [UIImage imageWithCGImage:subImageRef];

    //按比例缩放绘制
    CGFloat width = scaledImage.size.width / scale, height = scaledImage.size.height / scale;
    CGSize drawSize = CGSizeMake(width, height);
    
    UIImage *resultImg = nil;
    @autoreleasepool {
        UIGraphicsBeginImageContext(drawSize);
        [scaledImage drawInRect:CGRectMake(0, 0, width, height)];
        resultImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    CGImageRelease(subImageRef);
    return resultImg;
}

+ (NSString *)dataEncodeImgToUpload:(UIImage *)image {
    NSMutableString *imgArrayStr = [[NSMutableString alloc] init];
    BOOL isWifi = [NetworkUnit isWifiNetWork];
    float compressionQuality = isWifi ? 0.6 : 0.3;
    NSData *imgData = UIImageJPEGRepresentation(image, compressionQuality);
    NSString *base64Str = [imgData base64Encoding];
//    NSString *urlEncode = [StringUtil urlEncode:base64Str]; 重复encode ASI会加密一次
    [imgArrayStr appendFormat:@"[\".jpg\",\"%@\"]", base64Str];

    return (NSString *) imgArrayStr;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
                        withFrame:(CGRect)rect
                  andCornerRadius:(CGFloat)cornerRadius{
    UIImage *theImage = [ImageUtil createImageWithColor:color
                                              withFrame:rect
                                        andCornerRadius:cornerRadius
                                    andImageRoundCorner:ImageRoundCornerALL];
    return theImage;
}

+ (UIImage *)createImageWithColor:(UIColor *)color
                        withFrame:(CGRect)rect
                  andCornerRadius:(CGFloat)cornerRadius
              andImageRoundCorner:(ImageRoundCorner)imageRoundCorner{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    
    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);
    
    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minx, midy);
    
    if(imageRoundCorner & ImageRoundCorner_TopLeft){
        CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerRadius);
        CGContextAddLineToPoint(context, midx, miny);
    }
    else{
        CGContextAddLineToPoint(context, minx, miny);
        CGContextAddLineToPoint(context, midx, miny);
    }
    
    if(imageRoundCorner & ImageRoundCorner_TopRight){
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerRadius);
        CGContextAddLineToPoint(context, maxx, midy);
    }
    else{
        CGContextAddLineToPoint(context, maxx, miny);
        CGContextAddLineToPoint(context, maxx, midy);
    }
    
    if(imageRoundCorner & ImageRoundCorner_BottomRight){
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerRadius);
        CGContextAddLineToPoint(context, midx, maxy);
    }
    else{
        CGContextAddLineToPoint(context, maxx, maxy);
        CGContextAddLineToPoint(context, midx, maxy);
    }
    
    if(imageRoundCorner & ImageRoundCorner_BottomLetf){
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerRadius);
        CGContextAddLineToPoint(context, minx, midy);
    }
    else{
        CGContextAddLineToPoint(context, minx, maxy);
        CGContextAddLineToPoint(context, minx, midy);
    }
    
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


/* blur the current image with a box blur algoritm */
+ (UIImage *)blurryImage:(UIImage *)originalImg withBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }

    int boxSize = (int) (blur * 100);
    boxSize -= (boxSize % 2) + 1;

    CGImageRef img = originalImg.CGImage;

    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;

    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void *) CFDataGetBytePtr(inBitmapData);

    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
            0, 0, boxSize, boxSize, NULL,
            kvImageEdgeExtend);


    if (error) {
        
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
            outBuffer.data,
            outBuffer.width,
            outBuffer.height,
            8,
            outBuffer.rowBytes,
            colorSpace,
            CGImageGetBitmapInfo(originalImg.CGImage));

    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);

    return returnImage;
}


+ (void)circleImgAction:(UIImageView *)view {
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = YES;
    rotate.fillMode = kCAFillModeForwards;
    [rotate setToValue:[NSNumber numberWithFloat:M_PI]];
    rotate.repeatCount = INT_MAX;
    rotate.duration = 0.8;
    rotate.cumulative = YES;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [view.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

/*
 * 图片加水印
 */
+ (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage {
    UIGraphicsBeginImageContext(useImage.size);
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    CGFloat width = useImage.size.width / 1000 * 355;
    CGFloat height = floorf(width * maskImage.size.height / maskImage.size.width);
    [maskImage drawInRect:CGRectMake(useImage.size.width - width, useImage.size.height - height, width, height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

+ (UIImage *)imageName:(NSString *)imageName{
    UIImage *img = [UIImage imageNamed:imageName];
    img = [self zoomToSize:img size:CGSizeMake(GTFixWidthFlaot(img.size.width), GTFixHeightFlaot(img.size.height))];
    return img;
}

+ (UIImage *)imageNameIPad:(NSString *)imageName{
    UIImage *img = [UIImage imageNamed:imageName];
    img = [self zoomToSize:img size:HBSizeIpadOfSize(img.size)];
    return img;
}


@end
