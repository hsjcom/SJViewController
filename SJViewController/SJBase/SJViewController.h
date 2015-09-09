//
//  SJViewController.h
//
//
//  Created by Soldier on 15-1-28.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJHTTPRequest.h"
#import "HBEmptyView.h"
#import "HBErrorView.h"
#import "HBLoadMessageBox.h"



@class HBProcessIndicator;

@interface SJViewController : UIViewController<HBErrorViewDelegate>{
    HBProcessIndicator *_indicator;
    HBEmptyView *_emptyView;
    HBErrorView *_errorView;
    HBLoadMessageBox *_loadMsgBox;
    UILabel *backTitleLabel;
}

/**
 * 是否显示 返回按钮
 */
@property(assign,nonatomic) BOOL presentBackBtn;

/**
 * 设置  push 所传参数
 */
@property(strong,nonatomic) NSDictionary *query;

@property(nonatomic, strong) HBEmptyView *emptyView;

- (BOOL)ensureShowOtherView;

/**
 * 右滑返回，default YES
 */
- (BOOL)canDragBack;

/**
 * controller 传参
 * by soldier
 */
- (id)initWithQuery:(NSDictionary *)query;

/**
 * 判断是否是几大首页
 */
- (BOOL)isRootView;

/**
 * 返回,可自定义重写
 */
- (void)backView;

/**
 * 返回方法,可自定义重写,可以控制动画效果
 */
- (void)backView:(BOOL)animated;

/**
 * 侧滑返回。点击返回 --都可自定义重写
 */
- (void)backViewForSideslip;

/**
 * 自定义返回按钮 文字设置 若需要则重载
 */
- (NSString *)backButtonTilte;

/**
 * 自定义返回按钮 宽度
 */
- (CGFloat)setBackBtnWidth;

/**
 * 自定义下一页返回按钮 文字设置 若需要则重载
 */
- (NSString *)backButtonTilteOfNext;

/**
 * 导航栏右边按钮
 */
- (void)addNavRightBtn:(UIView *)btn;

/**
 * 导航栏右按钮 文字按钮
 */
- (void)constructNavRightBtn:(NSString *)title action:(SEL)action width:(CGFloat)width;

//!如果设置此方法，则iOS7以上侧滑功能会实效
- (void)addNavLeftBtn:(UIView *)btn;

- (void)removeNavRightBtn;

- (CGFloat)selfNavigatorHeight;

- (CGFloat)selfStatusAndNavigatorHeight;

- (UIColor *)navigationBarColor;

- (UIColor *)backgroundColor;

- (UIColor *)leftNavigationItemColor;

- (UIColor *)leftNavigationItemHightLightColor;

- (UIFont *)leftNavigationItemFont;

- (UIFont *)rightNavigationItemFont;

- (CGRect)rightBtnFrame;

- (UIColor *)rightNavigationItemColor;

- (UIColor *)rightNavigationItemHightLightColor;

/**
 * 导航栏标题
 */
- (void)addNavTitleView:(UIView *)titleView;

/**
 * 显示正在加载
 */
- (void)showLoading:(BOOL)show;

/**
 * 显示空页面
 */
- (void)showEmpty:(BOOL)show;

- (void)getEmptyView;

/**
 * 显示加载失败页面
 */
- (void)showError:(BOOL)show;

/**
 * 弹框时是否关闭交互
 */
- (BOOL)userInteractionEnabledWhenShowIndicator;

/**
 * 黑色提醒，渐显，自适应文本，支持多行，换行，\n 换行
 */
- (void)showMsg:(NSString *)msg;

/**
 * 黑色提醒（同上），延后
 */
- (void)showMsgDelay:(NSString *)msg;

//黑色提醒(同上)，加载windows
- (void)showMsgOnWindows:(NSString *)msg;

//黑色提醒(同上)，windows层，延后
- (void)showMsgOnWindowsDelay:(NSString *)msg;

/**
 * NavigationBar 下面红色提醒，从上往下
 */
- (void)showHopTip:(NSString *)msg;

/**
 * 转圈，userInteractionEnabled = [self userInteractionEnabledWhenShowIndicator];
 */
- (void)showIndicator:(NSString *)msg;

/**
 * 转圈，userInteractionEnabled = YES;
 */
- (void)showIndicatorWithUserInteractionEnabled:(NSString *)msg;

/**
 * 关闭转圈
 */
- (void)endIndicator;

/**
 * diamiss关闭转圈
 */
- (void)endIndicatorDelay;

/**
 * endIndicatorDelay同名方法
 */
- (void)endProcessDelay;

/**
 * 关闭转圈，并显示okIcon和msg
 */
- (void)endIndicatorWithIconAndMsg:(NSString *)msg;

/**
 * 关闭转圈，并显示msg
 */
- (void)endIndicator:(NSString *)msg;

/**
 * 关闭转圈，并显示title，subTitle，不同字体
 */
- (void)endIndicator:(NSString *)title subTitle:(NSString *)subTitle;

- (void)tabClickrefreshData;


@end
