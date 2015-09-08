//
//  HBEmptyView.h
//  
//
//  Created by Shaojie Hong on 15/2/26.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

@interface HBEmptyView : UIView{
    UIView *_baseView; //底座
    UILabel *_label; //基本文本
    UIButton *_button; //基本按钮
}

@property(nonatomic, strong)UIImageView *imageView; //基本图片

@property(nonatomic, readonly)UILabel *label;
//设置图片
- (void)setImage:(UIImage *)image;

//设置文本
- (void)setLabelText:(NSString *)labelText;

//设置图片和文本
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText;

//设置图片和文本，以及文本位置
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
   labelYPadding:(CGFloat)labelPadding;

//设置图片，文本和按钮，
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
          button:(UIButton *)button;

//设置图片，文本和按钮，以及文本，按钮位置
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
   labelYPadding:(CGFloat)labelPadding
          button:(UIButton *)button
     btnYPadding:(CGFloat)yPadding;


@end