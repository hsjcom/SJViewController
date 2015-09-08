//
//  HBMessageBox.m
//
//
//  Created by Soldier on 14-3-3.
//  Copyright (c) 2014年 Soldier. All rights reserved.
//

#import "HBMessageBox.h"
#import "SJBounceAnimation.h"

@implementation HBMessageBox
@synthesize msgLabel = _msgLabel;
@synthesize titleLabel = _titleLabel;
@synthesize canBack = _canBack;
@synthesize shouldAnimation = _shouldAnimation;

- (id)initWithIcon:(UIImage *)icon
           andText:(NSString *)labelText {
    self = [self initWithFrame:CGRectZero andIcon:icon andText:labelText];
    self.alpha = 0.85;
    return self;
}

- (id)initWithFrame:(CGRect)frame
            andIcon:(UIImage *)icon
            andText:(NSString *)labelText {
    CGRect backgroundFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - [HBMessageBox selfStatusAndNavHeight]);
    if (!icon && [StringUtil isEmpty:labelText]) {
        return nil;
    }
    self = [super initWithFrame:backgroundFrame];
    if (self) {
        self.alpha = 0.85;
        _msgBoxFrame = frame;
        _canBack = YES;
        self.shouldAnimation = YES;
        [self constructViewWithIcon:icon andLabel:labelText];
    }
    return self;
}

- (id)initWithTitle:(NSString *)titleText
          titleFont:(UIFont *)titleFont
         titleColor:(UIColor *)titleColor
    andMessageLabel:(NSString *)msgText
            msgFont:(UIFont *)msgFont
           msgColor:(UIColor *)msgColor {
    CGRect backgroundFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - [HBMessageBox selfStatusAndNavHeight]);
    if ([StringUtil isEmpty:titleText] && [StringUtil isEmpty:msgText]) {
        return nil;
    }
    self = [super initWithFrame:backgroundFrame];
    if (self) {
        self.alpha = 0.85;
        _msgBoxFrame = CGRectZero;
        _canBack = YES;
        self.shouldAnimation = YES;
        [self constructViewWithTitleLabel:titleText
                                titleFont:titleFont
                               titleColor:titleColor
                          andMessageLabel:msgText
                                  msgFont:msgFont
                                 msgColor:msgColor];
    }
    return self;
}

- (void)setShouldAnimation:(BOOL)shouldAnimation {
    if (shouldAnimation) {
        _shouldAppearAnimation = YES;
        _shouldDisAppearAnimation = YES;

    }
    else {
        _shouldAppearAnimation = NO;
        _shouldDisAppearAnimation = NO;
    }
    _shouldAnimation = shouldAnimation;
}

+ (CGFloat)selfStatusAndNavHeight {
    return StatusBarHeight + 49;
}

- (void)setCanBack:(BOOL)canBack {
    _canBack = canBack;
    if (!canBack) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        CGFloat yStart = floorf(([UIScreen mainScreen].bounds.size.height - 90) / 2);
        _msgBox.frame = CGRectMake(_msgBox.origin.x, yStart, _msgBox.width, _msgBox.height);
    }
}

- (void)constructViewWithIcon:(UIImage *)icon
                     andLabel:(NSString *)labelText {
    self.backgroundColor = [UIColor clearColor];
    BOOL isSingleContent = NO;
    if (!icon || [StringUtil isEmpty:labelText]) {
        isSingleContent = YES;
    }

    if (!_msgBox) {
        _msgBox = [[UIImageView alloc] init];
    }
    _msgBox.layer.cornerRadius = 5;
    _msgBox.backgroundColor = RGBACOLOR(0, 0, 0, 0.75f);
    _msgBox.layer.masksToBounds = YES;
    CGSize textSize = CGSizeZero;
    CGFloat width = 48.f;
    CGFloat height = 0.f;
    if (CGRectEqualToRect(_msgBoxFrame, CGRectZero)) {

        if (isSingleContent) {
            height = 20.;
        }
        else {
            height = 30.f;
        }

        if (icon) {
            width += icon.size.width;
            height += icon.size.height;
        }

        if (![StringUtil isEmpty:labelText]) {
            textSize = [labelText sizeWithFont:[UIFont systemFontOfSize:19]];
            if (textSize.width + 48 > width) {
                width = textSize.width + 48;
            }

            height += textSize.height;
            //同时存在增加间隔
            if (icon) {
                height += 15;
            }
        }
        _msgBox.frame = CGRectMake(floorf((self.width - width) / 2), floorf((self.height - height - [HBMessageBox selfStatusAndNavHeight]) / 2), width, height);
    }
    else {
        _msgBox.frame = _msgBoxFrame;

    }

    CGFloat nextHeight = 0.f;
    if (icon) {
        if (!_icon) {
            _icon = [[UIImageView alloc] init];
        }
        _icon.image = icon;
        nextHeight += isSingleContent ? 10 : 15;

        _icon.frame = CGRectMake(floorf((_msgBox.width - icon.size.width) / 2), nextHeight, icon.size.width, icon.size.height);
        _icon.backgroundColor = [UIColor clearColor];
        [_msgBox addSubview:_icon];
        nextHeight += _icon.width;
    }

    if (![StringUtil isEmpty:labelText]) {
        if (!_msgLabel) {
            _msgLabel = [ViewConstructUtil constructLabel:CGRectZero text:labelText font:[UIFont systemFontOfSize:19] textColor:[UIColor whiteColor]];
        }

        nextHeight += isSingleContent ? 10 : 15;
        _msgLabel.frame = CGRectMake(0, nextHeight, _msgBox.width, textSize.height);
        _msgLabel.numberOfLines = 1;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.backgroundColor = [UIColor clearColor];
        [_msgBox addSubview:_msgLabel];
    }
}

- (void)constructViewWithTitleLabel:(NSString *)titleText
                          titleFont:(UIFont *)titleFont
                         titleColor:(UIColor *)titleColor
                    andMessageLabel:(NSString *)msgText
                            msgFont:(UIFont *)msgFont
                           msgColor:(UIColor *)msgColor {
    if (!_msgBox) {
        _msgBox = [[UIImageView alloc] init];
    }
    _msgBox.layer.cornerRadius = 5;
    _msgBox.backgroundColor = RGBACOLOR(0, 0, 0, 0.75f);
    _msgBox.layer.masksToBounds = YES;

    CGSize titleSize = [titleText sizeWithFont:titleFont];
    CGSize msgSize = [msgText sizeWithFont:msgFont];
    CGFloat width = msgSize.width + 30 > 150 ? msgSize.width + 30 : 150;
    CGFloat height = ![StringUtil isEmpty:titleText] ? titleSize.height + msgSize.height + 30 : msgSize.height + 20;
    height = height > 75 ? height : 75;
    CGFloat top = 15;
    _msgBox.frame = CGRectMake(floorf((self.width - width) / 2), floorf((self.height - height - [HBMessageBox selfStatusAndNavHeight]) / 2), width, height);

    if (![StringUtil isEmpty:titleText]) {
        if (!_titleLabel) {
            _titleLabel = [ViewConstructUtil constructLabel:CGRectZero text:titleText font:titleFont textColor:titleColor];
        }
        _titleLabel.frame = ![StringUtil isEmpty:msgText] ? CGRectMake(floorf((_msgBox.width - titleSize.width) / 2), top, titleSize.width, titleSize.height) : CGRectMake(floorf((_msgBox.width - titleSize.width) / 2), floorf((_msgBox.height - titleSize.height) / 2), titleSize.width, titleSize.height);
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_msgBox addSubview:_titleLabel];

        top = _titleLabel.bottom + 5;
    }
    if (![StringUtil isEmpty:msgText]) {
        if (!_msgLabel) {
            _msgLabel = [ViewConstructUtil constructLabel:CGRectZero text:msgText font:msgFont textColor:msgColor];
        }
        _msgLabel.frame = ![StringUtil isEmpty:titleText] ? CGRectMake(floorf((_msgBox.width - msgSize.width) / 2), top, msgSize.width, msgSize.height) : CGRectMake(floorf((_msgBox.width - msgSize.width) / 2), floorf((_msgBox.height - msgSize.height) / 2), msgSize.width, msgSize.height);
        _msgLabel.numberOfLines = 1;
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.backgroundColor = [UIColor clearColor];
        [_msgBox addSubview:_msgLabel];
    }
}

- (void)show {
    if (!_msgBox) {
        return;
    }

    if (_shouldAppearAnimation) {
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.4;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
        popAnimation.keyTimes = @[@0.1f, @0.65f, @0.8f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [_msgBox.layer addAnimation:popAnimation forKey:nil];
    }
    [self addSubview:_msgBox];
    [self showAction];
}

- (void)showAndDuration:(NSTimeInterval)delay {
    if (!_msgBox) {
        return;
    }
    if (_shouldAppearAnimation) {
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.4;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2f, 1.2f, 1.0f)],
                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)]];
        popAnimation.keyTimes = @[@0.1f, @0.65f, @0.8f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        [_msgBox.layer addAnimation:popAnimation forKey:nil];
    }
    [self addSubview:_msgBox];
    [self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

- (void)showWithBounceAndPositionAnimation {
    if (!_msgBox) {
        return;
    }
    if (_shouldAppearAnimation) {
        [self addSubview:_msgBox];

        [self performSelector:@selector(bounceAnimationToPoint:) withObject:nil afterDelay:1.5];

        [self performSelector:@selector(hide) withObject:nil afterDelay:1.7];
    }
}

- (void)bounceAnimationToPoint:(CGPoint)point {
    _msgBox.frame = CGRectMake(self.width * 0.5 - _msgBox.width * 0.5, self.height * 0.5 - _msgBox.height * 0.5, _msgBox.width, _msgBox.height);
    CGPoint currentCenter = CGPointMake(_msgBox.centerX + self.width / 2, _msgBox.centerY + self.height / 2);
    CGPoint toPoint = CGPointMake(_msgBox.centerX + self.width / 2, _msgBox.centerY + self.height * 1.3);

    SJBounceAnimation *animation = [SJBounceAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCGPoint:currentCenter];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.duration = 6.0f;
    animation.numberOfBounces = 4;
    animation.delegate = self;

    _msgBox.layer.position = point;

    [self.layer addAnimation:animation forKey:@"bounceAnimationToPoint"];
}

- (void)showAction {
    [self performSelector:@selector(hide) withObject:nil afterDelay:ShowTime];
}

- (void)hide {
    if (_shouldDisAppearAnimation) {
        [UIView animateWithDuration:TimeForDisAppear animations:^{
            _msgBox.alpha = 0.0f;
        }                completion:^(BOOL finish) {
            [self clear];
        }];

        //有闪影效果，重做 待进一步研究
//        _hideAnimation = [[CAKeyframeAnimation animationWithKeyPath:@"transform"] retain];
//        //增加微量防止动画消失时恢复原样效果
//        _hideAnimation.duration = TimeForDisAppear-0.1;
//        _hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
//                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
//                                  [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5f, 0.5f, 1.0f)]];
//        _hideAnimation.keyTimes = @[@0.1f, @0.2f,@0.8f];
//        _hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
//                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
//                                           [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
//        [_msgBox.layer addAnimation:_hideAnimation forKey:nil];
//        _hideAnimation.delegate = self;
//        [self performSelector:@selector(clear) withObject:nil afterDelay:TimeForDisAppear];
    }
    else {
        [self clear];
    }
}


- (void)clear {
    [_msgBox removeFromSuperview];
    [self removeFromSuperview];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

//强行退出
- (void)destoryViewForce {
    [self clear];
}

//延迟消失
- (void)delayDissmis {
    [UIView beginAnimations:@"hideMsgBoxAlpha" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0.5];
    self.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(hideAnimateStop)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [_msgBox.layer removeAllAnimations];
}

- (void)hideAnimateStop {
    [self clear];
}


@end
