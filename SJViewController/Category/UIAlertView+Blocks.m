//
//  UIAlertView+Blocks.m
//
//
//  Created by Shaojie Hong on 15/12/5.
//  Copyright © 2015年 Shaojie Hong. All rights reserved.
//

#import "UIAlertView+Blocks.h"

static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;

@implementation UIAlertView (Blocks)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitle:(NSString *)otherButton {
    NSArray *buttons;
    if (otherButton) {
        buttons = @[otherButton];
    }
    else {
        buttons = [NSArray array];
    }
    UIAlertView *alert = [UIAlertView showAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:buttons onCancel:nil onDismiss:nil];
    return alert;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                        otherButtonTitle:(NSString *)otherButton
                                onCancel:(CancelBlock)cancelled
                               onDismiss:(DismissBlock)dismissed {
    NSArray *buttons;
    if (otherButton) {
        buttons = @[otherButton];
    }
    else {
        buttons = [NSArray array];
    }
    UIAlertView *alert = [UIAlertView showAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:buttons onCancel:cancelled onDismiss:dismissed];
    return alert;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray *)otherButtons {
    
    UIAlertView *alert = [UIAlertView showAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtons  onCancel:nil onDismiss:nil];
    return alert;
}

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                       otherButtonTitles:(NSArray *)otherButtons
                                onCancel:(CancelBlock)cancelled
                               onDismiss:(DismissBlock)dismissed {
    if (cancelled) {
        _cancelBlock  = [cancelled copy];
    }
    
    if (dismissed) {
        _dismissBlock  = [dismissed copy];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    [alert show];
    return alert;
}

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [alertView cancelButtonIndex]) {
        if (_cancelBlock) {
            _cancelBlock();
        }
    }
    else {
        if (_dismissBlock) {
            _dismissBlock(buttonIndex - 1.0); // cancel button is button 0
        }
    }  
}

@end