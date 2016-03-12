//
//  UIView+SJ.m
//  
//
//  Created by Soldier on 15-2-6.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "UIView+SJ.h"

@implementation UIView (SJ)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)screenX {
    CGFloat x = 0;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}

- (CGFloat)screenY {
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}

- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView *view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            x -= scrollView.contentOffset.x;
        }
    }
    return x;
}

- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView *view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}

- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIView *)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView *child in self.subviews) {
        UIView *it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    return nil;
}

- (UIView *)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

- (CGPoint)offsetFromView:(UIView *)otherView {
    CGFloat x = 0, y = 0;
    for (UIView *view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

/*
 * Label上下居中
 * return:  一行的高度
 */
+ (void)setSubviewCenterOnVertical:(UIView *)subView AtX:(CGFloat)xStart superView:(UIView *)superView{
    if (![superView isKindOfClass:[UIView class]]) {
        return;
    }
    
    subView.origin = CGPointMake(xStart, floorf((superView.height - subView.height)/2));
}

/*
 * UIView左右居中
 * return:  一行的高度
 */
+ (void)setSubviewCenterOnHorizontal:(UIView *)subView AtY:(CGFloat)yStart superView:(UIView *)superView{
    if (![superView isKindOfClass:[UIView class]]) {
        return;
    }
    
    subView.origin = CGPointMake(floorf((superView.width - subView.width)/2), yStart);
}

/*
 * UIView上下左右居中
 * return:  一行的高度
 */
+ (void)setSubviewOnCenter:(UIView *)subView superView:(UIView *)superView{
    if (![superView isKindOfClass:[UIView class]]) {
        return;
    }
    
    subView.origin = CGPointMake(floorf((superView.width - subView.width)/2), floorf((superView.height - subView.height)/2));
}

/**
 *  设置圆角矩形
 */
-(void)setViewCornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
    self.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setViewCornerRadius:(CGFloat)cornerRadius
                borderColor:(UIColor *)borderColor
                borderWidth:(CGFloat)borderWidth {
    if (cornerRadius > 0) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
    }
    
    if (borderWidth > 0) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.CGColor;
    }
}

/**
 *  获取当前view所在的controller
 */
- (UIViewController *)viewOfController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

@end
