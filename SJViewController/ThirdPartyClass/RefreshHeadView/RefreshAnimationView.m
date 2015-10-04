//
//  RefreshAnimationView.m
//  
//
//  Created by Soldier on 15-2-6.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "RefreshAnimationView.h"

#define kMaxRepeatCount 200

@implementation RefreshAnimationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createRefreshView];
        [self creatLoadingView];
    }
    return self;
}

- (void)createRefreshView {
    _refreshViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(self.width * 0.5 - 24 * 0.5, self.height * 0.5 - 24 * 0.5, 24, 24)];
    _refreshViewBg.image = [UIImage imageNamed:@"refreshImage.png"];
    [self addSubview:_refreshViewBg];
}

- (void)creatLoadingView {
    _refreshLoadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _refreshViewBg.width, _refreshViewBg.height)];
    _refreshLoadingView.image = [UIImage imageNamed:@"refreshLoading.png"];
    _refreshLoadingView.hidden = YES;
    [_refreshViewBg addSubview:_refreshLoadingView];
}

- (void)drawBackgroundCircle {
    CGContextRef contextBg = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(contextBg, 1.0);
    CGContextSetLineCap(contextBg, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(contextBg, [UIColor whiteColor].CGColor);
    CGFloat startAngleBg = M_PI / 2;
    CGFloat stepBg = 2 * M_PI;
    CGContextAddArc(contextBg, self.bounds.size.width / 2, self.bounds.size.height / 2, self.bounds.size.width / 2 - 3, startAngleBg, startAngleBg + stepBg, 0);
    CGContextStrokePath(contextBg);
}

- (void)drawRect:(CGRect)rect {
    [self drawBackgroundCircle];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, RGBCOLOR(255, 220, 40).CGColor);
    CGFloat startAngle = -M_PI / 2;
    CGFloat step = M_PI * 2 * self.progress;
    CGContextAddArc(context, self.bounds.size.width / 2, self.bounds.size.height / 2, self.bounds.size.width / 2 - 3, startAngle, startAngle + step, 0);
    //    CGContextDrawPath(context, kCGPathStroke);
    CGContextStrokePath(context);
    
    //不完整圆
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGContextSetLineCap(context, kCGLineCapRound);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGFloat startAngle = - M_PI / 3;
//    CGFloat step = 11 * M_PI / 6 * self.progress;
//    CGContextAddArc(context, self.bounds.size.width / 2, self.bounds.size.height / 2, self.bounds.size.width / 2 - 3, startAngle, startAngle+step, 0);
//    CGContextStrokePath(context);
}

- (void)pullingAnimation:(float)progress {
    self.progress = progress;
    [self setNeedsDisplay];
}

- (void)loadingAnimation {
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    [rotate setToValue:[NSNumber numberWithFloat:M_PI]];
    rotate.repeatCount = kMaxRepeatCount;
    rotate.duration = 0.3;
    rotate.cumulative = YES;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];

    [_refreshLoadingView.layer addAnimation:rotate forKey:@"rotateAnimation"];
    
    //转圈
    [self.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

- (void)startLoadingAnimation {
    _refreshLoadingView.hidden = NO;
    [self loadingAnimation];
}

- (void)stopLoadingAnimation {
    _refreshLoadingView.hidden = YES;
    [_refreshLoadingView.layer removeAllAnimations];
    
    [self.layer removeAllAnimations];
}

@end
