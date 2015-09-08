//
//  HBLoadMessageBox.m
//  
//
//  Created by Soldier on 14-3-3.
//  Copyright (c) 2014年 Soldier. All rights reserved.
//

#import "HBLoadMessageBox.h"
#import "ImageUtil.h"

#define PerUpdateTimeInterval 0.033
#define ChangeViewTimeInterval 0.1

@implementation HBLoadMessageBox

- (id)initWithLoadingText:(NSString *)loadingText {
    NSString *finishText = nil;
    return [self initWithLoadingText:loadingText andFinishText:finishText];
}

- (id)initWithLoadingText:(NSString *)loadingText
            andFinishText:(NSString *)finishText {
    UIImage *loadingImg = [UIImage imageNamed:@"IconForBlackCircle.png"];
    self = [super initWithIcon:loadingImg andText:loadingText];
    if (self) {
        self.userInteractionEnabled = NO;
        _finishText = finishText;
    }

    return self;
}

- (void)showAction {
    [ImageUtil circleImgAction:_icon];
}

- (void)finishWithMessage:(NSString *)finishMsg {
    _finishText = finishMsg;
    [self finish];
}

- (void)finish {
    if ([StringUtil isEmpty:_finishText]) {
        [self destoryViewForce];
        return;
    }

    CGSize size = [_finishText sizeWithFont:[UIFont systemFontOfSize:19]];
    CGFloat width = size.width + 34;

    [UIView animateWithDuration:ChangeViewTimeInterval animations:^{
        //icon旋转到一半时，需隐去还原位置
        _icon.alpha = 0.0;
        _msgLabel.text = _finishText;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.height);
    }                completion:^(BOOL finish) {
        //隐去后还原位置
        [_icon.layer removeAllAnimations];
        _icon.layer.affineTransform = CGAffineTransformIdentity;
        _icon.alpha = 1.0f;
        _icon.image = [UIImage imageNamed:@"loadedFinish.png"];
        [self performSelector:@selector(hide) withObject:nil afterDelay:ShowTime];
    }];
}


@end
