//
//  UIAlertView+Blocks.h
//
//
//  Created by Shaojie Hong on 15/12/5.
//  Copyright © 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DismissBlock)(int buttonIndex);
typedef void (^CancelBlock)();

@interface UIAlertView (Blocks) <UIAlertViewDelegate>

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitle:(NSString *)otherButton;

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitle:(NSString *)otherButton
                                onCancel:(CancelBlock)cancelled
                               onDismiss:(DismissBlock)dismissed;

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                       otherButtonTitles:(NSArray *)otherButtons;

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                       otherButtonTitles:(NSArray *)otherButtons
                                onCancel:(CancelBlock)cancelled
                               onDismiss:(DismissBlock)dismissed;

@end
