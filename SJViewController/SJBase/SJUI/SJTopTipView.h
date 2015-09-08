//
//  SJTopTipView.h
//
//
//  Created by Soldier on 15/3/2.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

/*
 * 自适应文本：多行，自动换行，\n 换行
 * by Soldier
 */

typedef enum {
    ShowAlphaMsg = 1,
    ShowTipMsg = 2,
} ShowType;

@interface SJTopTipView : UIView {
    UILabel *_label;
    NSTimeInterval _showTimeInterval;
    NSTimeInterval _hideTimeInterval;
    ShowType _showType;
}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSTimeInterval showTimeInterval;
@property (nonatomic, assign) NSTimeInterval hideTimeInterval;
@property (nonatomic, assign) BOOL userInteractionEnabledWhenShow; //default NO

- (id)initWithView:(UIView *)view msg:(NSString *)msg;

- (id)initWithWindows:(UIWindow *)window msg:(NSString *)msg;

- (id)initWithView:(UIView *)view attributedString:(NSAttributedString *)attributedString;

//黑色提醒，渐显
- (void)showMessage;

//navigation下面红色提醒，从上往下
- (void)showTipMessage;

+ (void)showMsgOnWindows:(NSString *)msg;

+ (void)showMsgWithAttributedString:(NSAttributedString *)attributedString inView:(UIView *)view;


@end
