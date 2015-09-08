//
//  SJTopTipView.m
//
//
//  Created by Soldier on 15/3/2.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJTopTipView.h"

@implementation SJTopTipView

- (id)initWithView:(UIView *)view msg:(NSString *)msg {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabledWhenShow = NO;
        [view addSubview:self];
        UIFont *font = Isipad() ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:16];
        UIColor *color = [UIColor whiteColor];
        _label = [ViewConstructUtil constructLabel:CGRectZero
                                               text:msg
                                               font:font
                                          textColor:color];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    return self;
}

- (id)initWithWindows:(UIWindow *)window msg:(NSString *)msg {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabledWhenShow = NO;
        [window addSubview:self];
        UIFont *font = Isipad() ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:16];
        UIColor *color = [UIColor whiteColor];
        _label = [ViewConstructUtil constructLabel:CGRectZero
                                              text:msg
                                              font:font
                                         textColor:color];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    
    return self;
}

- (id)initWithView:(UIView *)view attributedString:(NSAttributedString *)attributedString {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabledWhenShow = NO;
        [view addSubview:self];
        UIFont *font = Isipad() ? [UIFont systemFontOfSize:18] : [UIFont systemFontOfSize:16];
        UIColor *color = [UIColor whiteColor];
        _label = [ViewConstructUtil constructLabel:CGRectZero
                                              text:nil
                                              font:font
                                         textColor:color];
        _label.attributedText = attributedString;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    return self;
}

#pragma mark - showTipMessage

- (void)showTipMessage {
    _showType = ShowTipMsg;
    self.backgroundColor = RGBACOLOR(255, 57, 51, 0.8);
    _showTimeInterval = 0.55;
    _hideTimeInterval = 1.2;
    [self layoutSubviews];
    [self show];
}

- (void)show {
    self.superview.userInteractionEnabled = self.userInteractionEnabledWhenShow;
    
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:_showTimeInterval];
    self.center = CGPointMake(self.centerX, self.centerY + self.height);
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hide)];
    [UIView commitAnimations];
}

- (void)hide {
    [UIView beginAnimations:@"hideHopTip" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:_showTimeInterval];
    [UIView setAnimationDelay:_hideTimeInterval];
    [UIView setAnimationDidStopSelector:@selector(hideAnimateStop)];
    [UIView setAnimationDelegate:self];
    self.center = CGPointMake(self.centerX, self.centerY - self.height);
    [UIView commitAnimations];
}

- (void)hideAnimateStop {
    self.superview.userInteractionEnabled = YES;
    [self removeFromSuperview];
}

#pragma mark - showMessage

- (void)showMessage {
    _showType = ShowAlphaMsg;
    self.layer.cornerRadius = 5;
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.65);
    _showTimeInterval = 0.55;
    _hideTimeInterval = 1;

    [self layoutSubviews];
    [self showAlpha];
}

- (void)showAlpha {
    self.superview.userInteractionEnabled = self.userInteractionEnabledWhenShow;
    
    self.alpha = 0.0;
    [UIView beginAnimations:@"showAlpha" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:_showTimeInterval];
    self.alpha = 1.0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideAlpha)];
    [UIView commitAnimations];
}

- (void)hideAlpha {
    [UIView beginAnimations:@"hideHopTipAlpha" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDelay:_hideTimeInterval];
    self.alpha = 0;
    [UIView setAnimationDidStopSelector:@selector(hideAnimateStop)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)layoutSubviews {
    [super layoutSubviews];
     [_label sizeToFit];
    
    CGFloat width = _showType == ShowTipMsg ? UI_SCREEN_WIDTH : _label.width + 30 >= (UI_SCREEN_WIDTH - 30) ? UI_SCREEN_WIDTH - 30 : _label.width + 30;
    width = width <= 150 ? 150 : width;
    CGFloat height = _label.height + 40;
    height = _showType == ShowTipMsg ? height - 20 : height <= 85 ? 85 : height;
    CGFloat top = _showType == ShowTipMsg ? 0 : self.superview.height * 0.5 - height * 0.5;
    CGFloat left = _showType == ShowTipMsg ? 0 : UI_SCREEN_WIDTH * 0.5 - width * 0.5;
    [self setWidth: width];
    [self setHeight:height];
    
    self.frame = CGRectMake(left, top, width, height);
    
    CGFloat labelWidth = width - 30;
    _label.frame = CGRectMake(floorf((self.width - labelWidth) / 2), floorf((self.height - _label.height) / 2), labelWidth, _label.height);
}

+ (void)showMsgOnWindows:(NSString *)msg {
    if ([StringUtil isEmpty:msg]) {
        return;
    }
    SJTopTipView *tip = [[SJTopTipView alloc] initWithWindows:HB_Keywindow msg:msg];
    [tip showMessage];
}

+ (void)showMsgWithAttributedString:(NSAttributedString *)attributedString inView:(UIView *)view {
    SJTopTipView *tip = [[SJTopTipView alloc] initWithView:view attributedString:attributedString];
    [tip showMessage];
}

@end
