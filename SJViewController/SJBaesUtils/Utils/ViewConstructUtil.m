//
//  ViewConstructUtil.m
//  
//
//  Created by Shaojie Hong on 15/2/9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "ViewConstructUtil.h"


@implementation ViewConstructUtil

/*
 * 创建基本Label，并且是居中
 */
+ (UILabel *)constructLabel:(CGRect)frame
                       text:(NSString *)text
                       font:(UIFont *)font
                  textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    if (font) {
        label.font = font;
    }
    if (color) {
        label.textColor = color;
    }
    if (text) {
        label.text = text;
    }
    label.userInteractionEnabled = NO;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

/*
 * 创建Label，大小自适应
 */
+ (UILabel *)constructLabelSizeToFitWithText:(NSString *)text
                                        font:(UIFont *)font
                                   textColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    if (font) {
        label.font = font;
    }
    if (color) {
        label.textColor = color;
    }
    
    if (text) {
        label.text = text;
    }
    [label sizeToFit];
    label.frame = CGRectMake(0, 0, label.width, label.height);
    
    
    return label;
}

/*
 * 基本创建HBButton
 */
+ (UIButton *)constructButton:(CGRect)frame
                         target:(id)target
                         action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = frame;
    return (UIButton *)btn;
}

/*
 * 基本创建UIButton,基于背景图片的
 */
+ (UIButton *)constructButton:(CGRect)frame
                      nlBgImg:(UIImage *)nlBgImg
                      hlBgImg:(UIImage *)hlBgImg
                      slBgImg:(UIImage *)slBgImg
                       target:(id)target
                       action:(SEL)action{
    UIButton *btn = [self constructButton:frame
                                   target:target
                                   action:action];
    if (nlBgImg) {
        [btn setBackgroundImage:nlBgImg forState:UIControlStateNormal];
    }
    if (hlBgImg) {
        [btn setBackgroundImage:hlBgImg forState:UIControlStateHighlighted];
    }
    if (slBgImg) {
        [btn setBackgroundImage:slBgImg forState:UIControlStateSelected];
    }
    return btn;
}

/*
 * 创建基本的UIButton,基于背景图片的
 */
+ (UIButton *)constructAutoLayoutButtonForNlBgImg:(UIImage *)nlBgImg
                                          hlBgImg:(UIImage *)hlBgImg
                                          slBgImg:(UIImage *)slBgImg
                                           target:(id)target
                                           action:(SEL)action{
    
    UIButton *btn = [self constructButton:CGRectZero
                                    target:target
                                    action:action];
    
    CGSize size = CGSizeZero;
    
    if (nlBgImg) {
        [btn setBackgroundImage:nlBgImg forState:UIControlStateNormal];
        size = nlBgImg.size;
    }
    if (hlBgImg) {
        [btn setBackgroundImage:hlBgImg forState:UIControlStateHighlighted];
        size = hlBgImg.size;
    }
    if (slBgImg) {
        [btn setBackgroundImage:slBgImg forState:UIControlStateSelected];
        size = slBgImg.size;
    }
    
    btn.size = HBSizeMake(size.width, size.height);
    
    return btn;
}

/*
 * 基本创建UIImageView,基于图片的名字的
 */
+ (UIImageView *)constructImageView:(CGRect)frame
                            imgName:(NSString *)imgName{
    UIImageView *result = [[UIImageView alloc] initWithFrame:frame];
    result.userInteractionEnabled = NO;
    UIImage *image = [UIImage imageNamed:imgName];
    result.image = image;
    result.clipsToBounds = YES;
    return result;
}

/*
 * 基本创建UIImageView
 */
+ (UIImageView *)constructImageView:(CGRect)frame{
    UIImageView *result = [[UIImageView alloc] initWithFrame:frame];
    result.userInteractionEnabled = NO;
    result.backgroundColor = [UIColor clearColor];
    result.clipsToBounds = YES;
    return result;
}

+ (UIImageView *)constructHBImgView:(NSString *)imgName{
    UIImageView *result = [[UIImageView alloc] init];
    result.userInteractionEnabled = NO;
    UIImage *image = [UIImage imageNamed:imgName];
    result.image = image;
    result.size = image.size;
    result.clipsToBounds = YES;
    return result;
    
}

/*
 * 基本创建HBImageView,基于图片的名字的
 */
+ (SJImageView *)constructHBImageView:(CGRect)frame
                              imgName:(NSString *)imgName
                             userInfo:(id)userInfo{
    SJImageView *result = [[SJImageView alloc] initWithFrame:frame];
    result.userInteractionEnabled = NO;
    UIImage *image = [UIImage imageNamed:imgName];
    result.image = image;
    result.userInfo = userInfo;
    result.clipsToBounds = YES;
    return result;
}


/*
 * 创建基本UITextField,基于delegate的
 */
+ (UITextField *)constructTextField:(id <UITextFieldDelegate>)delegate {
    UITextField *textField = [[UITextField alloc] init];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.layer.cornerRadius = 5;
    textField.delegate = delegate;
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

/*
 * 创建基本constructTextView,基于delegate的
 */
+ (UITextView *)constructTextView:(id <UITextViewDelegate>)delegate {
    UITextView *textView = [[UITextView alloc] init];
    textView.showsHorizontalScrollIndicator = NO;
    textView.delegate = delegate;
    textView.returnKeyType = UIReturnKeyDone;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.layer.cornerRadius = 5;
    return textView;
}

/*
 * 创建基本UIScrollView,基于frame的
 */
+ (UIScrollView *)constructScrollView:(CGRect)frame {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.autoresizesSubviews = YES;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return scrollView;
}

/*
 * view子类的复制方法
 */
+ (id)deepViewCopy:(id)view {
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    NSData *copyObj = [NSKeyedArchiver archivedDataWithRootObject:view];
    id copy = [NSKeyedUnarchiver unarchiveObjectWithData:copyObj];
    return copy;
}


@end
