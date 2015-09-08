//
//  HBProcessIndicator.m
//  
//
//  Created by Shaojie Hong on 15/2/26.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "HBProcessIndicator.h"
#import "ImageUtil.h"

static const CGFloat HideTimeIntervalDefault = 1.7;

@implementation HBProcessIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [ViewConstructUtil constructLabel:CGRectZero
                                              text:nil
                                              font:[UIFont systemFontOfSize:16]
                                         textColor:RGBCOLOR(160, 160, 160)];
        [self addSubview:_label];
        
        [self constructCustomIndicator];
    }
    return self;
}

- (void)constructCustomIndicator {
    if (!_customIndicator) {
        _customIndicator = [[UIImageView alloc] init];
    }
    
    _customIndicator.userInteractionEnabled = NO;
    UIImage *img = [UIImage imageNamed:@"IconForWhiteCircle"];
    _customIndicator.image = img;
    _customIndicator.size = HBSizeMake(img.size.width, img.size.height);
    [UIView setSubviewOnCenter:_customIndicator superView:self];
}

- (void)showCustomIndicator{
    _label.text = nil;
    [self showCustomIndicatorAnimation];
}

- (void)showCustomIndicatorWithMessage:(NSString *)msg {
    _label.text = msg;
    [_label sizeToFit];
    [UIView setSubviewCenterOnHorizontal:_label
                                     AtY:_customIndicator.bottom + GTFixHeightFlaot(10)
                               superView:self];

    [self showCustomIndicatorAnimation];
    
}

- (void)showCustomIndicatorAnimation {
    [UIView animateWithDuration:ImgAppearTime animations:^{
        [self addSubview:_customIndicator];
        _customIndicator.alpha = 1.0;
        [ImageUtil circleImgAction:_customIndicator];
    }                completion:^(BOOL finish) {
        
    }];
}

- (void)endCustomIndicator {
    _customIndicator.alpha = 0.0;
    [_customIndicator removeFromSuperview];
    _label.text = nil;
    [self hide];
}


- (void)showMessage:(NSString *)msg {
    _label.text = msg;
    _label.numberOfLines = 1;
    [_label sizeToFit];
    CGFloat width = _label.frame.size.width;
    if (_label.frame.size.width > 220) {
        _label.numberOfLines = 2;
        [_label sizeToFit];
    }
    
    _label.frame = CGRectMake(10, 6, width, _label.frame.size.height);
    CGRect frame = CGRectMake((self.superview.size.width - width - 20) / 2, self.superview.size.height / 2 - _label.frame.size.height - 50, _label.frame.size.width + 20, _label.frame.size.height + 12);
    self.frame = frame;
    self.alpha = 0.7;
    
    [self hide];
}

- (void)hide {
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:HideTimeIntervalDefault];
    [UIView setAnimationDelegate:self];
    self.alpha = 0.0f;
    [UIView commitAnimations];
    
//    [self removeFromSuperview];
}

@end
