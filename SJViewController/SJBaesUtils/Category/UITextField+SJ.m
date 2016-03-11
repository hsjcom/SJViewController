//
//  UITextField+SJ.m
//  DCSStore
//
//  Created by Soldier on 16/3/11.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "UITextField+SJ.h"

@implementation UITextField (SJ)

/**
 * 设置UITextField 左右边距
 */
- (void)setTextFieldMarginWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    UIView *leftView = [[UIView alloc] initWithFrame:frame];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
    
    UIView *rightView = [[UIView alloc] initWithFrame:frame];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = rightView;
}

@end
