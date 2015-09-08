//
//  HBMessageBox.h
//
//
//  Created by Soldier on 14-3-3.
//  Copyright (c) 2014年 Soldier. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ShowTime 1
#define TimeForAppear 0.4
#define TimeForDisAppear 0.3

@interface HBMessageBox : UIView {
    CGRect _msgBoxFrame;
    BOOL _canBack;
    UIImageView *_msgBox;
    UILabel *_msgLabel;
    UIImageView *_icon;
    CAKeyframeAnimation *_hideAnimation;
}
@property(nonatomic, assign) BOOL shouldAnimation;  //出现动画和消失动画
@property(nonatomic, assign) BOOL shouldAppearAnimation;
@property(nonatomic, assign) BOOL shouldDisAppearAnimation;
@property(nonatomic, strong) UILabel *msgLabel;
@property(nonatomic, strong) UILabel *titleLabel;
//用于扩张页面，使得页面是否可以返回
@property(nonatomic, assign) BOOL canBack;

- (void)show;

- (void)hide;

- (id)initWithFrame:(CGRect)frame
            andIcon:(UIImage *)icon
            andText:(NSString *)labelText;

- (id)initWithIcon:(UIImage *)icon
           andText:(NSString *)labelText;

- (id)initWithTitle:(NSString *)titleText
          titleFont:(UIFont *)titleFont
         titleColor:(UIColor *)titleColor
    andMessageLabel:(NSString *)msgText
            msgFont:(UIFont *)msgFont
           msgColor:(UIColor *)msgColor;

- (void)showAndDuration:(NSTimeInterval)delay;

- (void)showWithBounceAndPositionAnimation;


//强行退出
- (void)destoryViewForce;

- (void)clear;

- (void)delayDissmis;

@end
