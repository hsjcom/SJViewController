//
//  HBEmptyView.m
//  
//
//  Created by Shaojie Hong on 15/2/26.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "HBEmptyView.h"

const static CGFloat defaultLabelPadding = 15.f;
const static CGFloat defaultButtongPadding = 20.f;

@implementation HBEmptyView
@synthesize label = _label;
@synthesize imageView = _imageView;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self constructSubView];
    return self;
}

- (void)constructSubView{
    _baseView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_baseView];
    
    //imageView
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.userInteractionEnabled = NO;
    [_baseView addSubview:_imageView];
    
    
    //label
    _label = [ViewConstructUtil constructLabel:CGRectZero
                                          text:nil
                                          font:[UIFont systemFontOfSize:14]
                                     textColor:RGBCOLOR(184, 184, 184)];
    [_baseView addSubview:_label];
    
}


- (void)setImage:(UIImage *)image{
    [self setImage:image
         labelText:nil
     labelYPadding:0];
}

//设置文本
- (void)setLabelText:(NSString *)labelText{
    [self setImage:nil
         labelText:labelText
     labelYPadding:0];
}

//设置图片和文本
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText{
    [self setImage:image
         labelText:labelText
     labelYPadding:defaultLabelPadding];
}

//设置图片和文本，以及文本位置
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
   labelYPadding:(CGFloat)labelPadding{
    [self setImage:image
         labelText:labelText
     labelYPadding:labelPadding
            button:nil
       btnYPadding:0];
}

//设置图片，文本和按钮，
- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
          button:(UIButton *)button{
    [self setImage:image
         labelText:labelText
     labelYPadding:defaultLabelPadding
            button:button
       btnYPadding:defaultButtongPadding];
}


- (void)setImage:(UIImage *)image
       labelText:(NSString *)labelText
   labelYPadding:(CGFloat)labelPadding
          button:(UIButton *)btn
     btnYPadding:(CGFloat)btnYPadding{
    if (!image) {
        _imageView.frame = CGRectZero;
    }
    else{
        _imageView.image = image;
        _imageView.size = CGSizeMake(image.size.width, image.size.height);
    }
    
    
    if ([StringUtil isEmpty:labelText]) {
        _label.frame = CGRectZero;
        labelPadding = 0.f;
    }
    else{
        _label.text = labelText;
        _label.numberOfLines = 0;
        [_label sizeToFit];
    }
    
    if (!btn) {
        _button.frame = CGRectZero;
        btnYPadding = 0.f;
    }
    else {
        _button = btn;
        [_baseView addSubview:_button];
    }
    
    CGFloat baseHeight = _imageView.height + _label.height + _button.height + GTFixHeightFlaot(labelPadding + btnYPadding);
    _baseView.size = CGSizeMake(self.width, baseHeight);
    _baseView.origin = CGPointMake(self.width * 0.5 - _baseView.width * 0.5, Is3dot5Inch() ? 80 : GTFixHeightFlaotIpad(135));
//    [UIView setSubviewOnCenter:_baseView superView:self];
//    //提升20像素，以使页面看起来更舒适
//    _baseView.top -= GTFixHeightFlaot(20);
    
    CGFloat nextY = 0.f;
    [UIView setSubviewCenterOnHorizontal:_imageView AtY:nextY superView:_baseView];
    nextY += _imageView.height + GTFixHeightFlaot(labelPadding);
    
    [UIView setSubviewCenterOnHorizontal:_label AtY:nextY superView:_baseView];
    nextY += _label.height + GTFixHeightFlaot(btnYPadding);
    
    [UIView setSubviewCenterOnHorizontal:_button AtY:nextY superView:_baseView];
    
}

@end
