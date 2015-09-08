//
//  CLLRefreshCircleView.m
//  RefreshLoadView
//
//  Created by chuliangliang on 14-6-13.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "CLLRefreshCircleView.h"

@implementation CLLRefreshCircleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _heightBeginToRefresh = 50;
        _offsetY = 0;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


+ (CABasicAnimation*)repeatRotateAnimation {
    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
    rotateAni.duration = 0.25;
    rotateAni.cumulative = YES;
    rotateAni.removedOnCompletion = NO;
    rotateAni.fillMode = kCAFillModeForwards;
    rotateAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotateAni.toValue = [NSNumber numberWithFloat:M_PI / 2];
    rotateAni.repeatCount = MAXFLOAT;
    
    return rotateAni;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:173 / 255.0 green:53 / 255.0 blue:60 / 255.0 alpha:1].CGColor);
    CGContextSetLineWidth(context, 1.f);
    
    static CGFloat radius = 9;
    if (!_isRefreshViewOnTableView) {
        static CGFloat startAngle = M_PI / 2;
        CGFloat endAngle = (ABS(_offsetY) / _heightBeginToRefresh) * (M_PI * 19 / 10) + startAngle;
        CGContextAddArc(context, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2, radius, startAngle, endAngle, 0);
    } else {
        static CGFloat startAngle = 3 * M_PI / 2.0;
        CGFloat endAngle = (ABS(_offsetY) / _heightBeginToRefresh) * (M_PI * 19 / 10) + startAngle;
        CGContextAddArc(context, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2, radius, startAngle, endAngle, 0);
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
