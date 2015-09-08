//
//  HBProcessIndicator.h
//  
//
//  Created by Shaojie Hong on 15/2/26.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

@interface HBProcessIndicator : UIView {
    UIImageView *_customIndicator;
    UILabel *_label;
}

- (void)showMessage:(NSString *)msg;

- (void)showCustomIndicator;

- (void)showCustomIndicatorWithMessage:(NSString *)msg;

- (void)endCustomIndicator;

@end