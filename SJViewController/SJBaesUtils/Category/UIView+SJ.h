//
//  UIView+SJ.h
//  
//
//  Created by Soldier on 15-2-6.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SJ)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat screenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat screenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView *)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView *)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)offsetFromView:(UIView*)otherView;


/*
 * UIView上下居中
 * return:  一行的高度
 */
+ (void)setSubviewCenterOnVertical:(UIView *)subView AtX:(CGFloat)xStart superView:(UIView *)superView;

/*
 * UIView左右居中
 * return:  一行的高度
 */
+ (void)setSubviewCenterOnHorizontal:(UIView *)subView AtY:(CGFloat)yStart superView:(UIView *)superView;

/*
 * UIView上下左右居中
 * return:  一行的高度
 */
+ (void)setSubviewOnCenter:(UIView *)subView superView:(UIView *)superView;

/**
 *  设置圆角矩形
 */
- (void)setViewCornerRadius:(CGFloat)cornerRadius;

- (void)setViewCornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth;

/**
 *  获取当前view所在的controller
 */
- (UIViewController *)viewOfController;

@end






#pragma mark ===================== 适配相关  =====================
/**
 *  iphone6 适配
 *
 *  @param height
 *
 *  @return 保证取整或是0.5的倍数
 */
CG_INLINE CGFloat CGFloatForView(CGFloat value){
    CGFloat result = 0.f;
    int floorValue = floorf(value);
    float dif = value - floorValue;
    //四舍五入
    if (dif < 0.5f){
        result = floorf(value);
    }
    else{
        result = ceilf(value);
    }
    return result;
}


/**
 *  ipone6 适配
 *
 *  @param height
 *
 *  @return 等比放大
 */

CG_INLINE CGFloat GTFixHeightFlaot(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return height;
    }
    
    height = IsiPad() ? height*mainFrme.size.width/640*2 : height*mainFrme.size.height/1096*2 ;
    height = CGFloatForView(height);//需要取整，否则1像素分割线无法显示
    return height;
}


CG_INLINE CGFloat GTFixHeightFlaotIpad(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return height;
    }
    
    height = IsiPad() ? height*mainFrme.size.width/640*2*0.65 : height*mainFrme.size.height/1096*2 ;
    height = CGFloatForView(height);//需要取整，否则1像素分割线无法显示
    return height;
}


CG_INLINE CGFloat GTFixWidthFlaot(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return width;
    }
    width = width*mainFrme.size.width/640*2;
    width = CGFloatForView(width);//需要取整，否则1像素分割线无法显示
    return width;
}

CG_INLINE CGFloat GTFixWidthFlaotIpad(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return width;
    }
    
    width = IsiPad() ? width*mainFrme.size.width/640*2*0.65 : width*mainFrme.size.width/640*2; ;
    width = CGFloatForView(width);//需要取整，否则1像素分割线无法显示
    return width;
}

CG_INLINE CGFloat GTReHeightFlaot(CGFloat height) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return height;
    }
    height = IsiPad() ? height*640/mainFrme.size.width/2 : height*1096/(mainFrme.size.height*2);
    height = CGFloatForView(height);//需要取整，否则1像素分割线无法显示
    return height;
}

CG_INLINE CGFloat GTReWidthFlaot(CGFloat width) {
    CGRect mainFrme = [[UIScreen mainScreen] applicationFrame];
    if (mainFrme.size.height/1096*2 < 1) {
        return width;
    }
    width = width*640/mainFrme.size.width/2;
    width = CGFloatForView(width);//需要取整，否则1像素分割线无法显示
    return width;
}

// 经过测试了, 以iphone5屏幕为适配基础
CG_INLINE CGRect
GTRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = x; rect.origin.y = y;
    rect.size.width = GTFixWidthFlaot(width); rect.size.height = GTFixHeightFlaot(height);
    return rect;
}

CG_INLINE CGPoint
HBPointMake(CGFloat x, CGFloat y)
{
    CGPoint p;
    p.x = GTFixWidthFlaot(x);
    p.y = GTFixHeightFlaot(y);
    return p;
}

CG_INLINE CGPoint
HBPointMakeIpad(CGFloat x, CGFloat y)
{
    CGPoint p;
    p.x = GTFixWidthFlaotIpad(x);
    p.y = GTFixHeightFlaotIpad(y);
    return p;
}

CG_INLINE CGSize
HBSizeMake(CGFloat width, CGFloat height)
{
    CGSize size;
    size.width = GTFixWidthFlaot(width);
    size.height = GTFixHeightFlaot(height);
    return size;
}

CG_INLINE CGSize
HBSizeMakeIpad(CGFloat width, CGFloat height)
{
    CGSize size;
    size.width = GTFixWidthFlaotIpad(width);
    size.height = GTFixHeightFlaotIpad(height);
    return size;
}

CG_INLINE CGSize
HBSizeIpadOfSize(CGSize orgSize)
{
    CGSize size;
    size.width = GTFixWidthFlaotIpad(orgSize.width);
    size.height = GTFixHeightFlaotIpad(orgSize.height);
    return size;
}

CG_INLINE CGRect
HBRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = GTFixWidthFlaot(x); rect.origin.y = GTFixHeightFlaot(y);
    rect.size.width = GTFixWidthFlaot(width); rect.size.height = GTFixHeightFlaot(height);
    return rect;
}

CG_INLINE CGRect
HBRectMakeIpad(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = GTFixWidthFlaotIpad(x); rect.origin.y = GTFixHeightFlaotIpad(y);
    rect.size.width = GTFixWidthFlaotIpad(width); rect.size.height = GTFixHeightFlaotIpad(height);
    return rect;
}

//宽度维持不变的设置  主要用于全屏宽情况
CG_INLINE CGRect
HBRectFixWidthMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    CGRect rect;
    rect.origin.x = GTFixWidthFlaot(x); rect.origin.y = GTFixHeightFlaot(y);
    rect.size.width = width; rect.size.height = GTFixHeightFlaot(height);
    return rect;
}

CG_INLINE UIEdgeInsets
HBEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    CGFloat nTop = GTFixHeightFlaot(top);
    CGFloat nLeft = GTFixWidthFlaot(left);
    CGFloat nBottom = GTFixHeightFlaot(bottom);
    CGFloat nRight = GTFixWidthFlaot(right);
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(nTop,nLeft,nBottom,nRight);
    return edgeInset;
}

CG_INLINE UIEdgeInsets
HBEdgeInsetsMakeIpad(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
{
    CGFloat nTop = GTFixHeightFlaotIpad(top);
    CGFloat nLeft = GTFixWidthFlaotIpad(left);
    CGFloat nBottom = GTFixHeightFlaotIpad(bottom);
    CGFloat nRight = GTFixWidthFlaotIpad(right);
    UIEdgeInsets edgeInset = UIEdgeInsetsMake(nTop,nLeft,nBottom,nRight);
    return edgeInset;
}


