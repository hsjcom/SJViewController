//
//  HBErrorView.m
//  
//
//  Created by Shaojie Hong on 15/2/26.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "HBErrorView.h"

@implementation HBErrorView

@synthesize delegate;

- (void)dealloc{
    delegate = nil;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self constructSubviews];
    }
    return  self;
}

- (void)constructSubviews{
    UIImage *imageView = [UIImage imageNamed:@"noNetworkIcon"];
    
    UIButton *btn = [ViewConstructUtil constructAutoLayoutButtonForNlBgImg:[UIImage imageNamed:@"afreshLoad"]
                                                                   hlBgImg:[UIImage imageNamed:@"afreshLoad_hl"]
                                                                   slBgImg:[UIImage imageNamed:@"afreshLoad_hl"]
                                                                    target:self
                                                                    action:@selector(refresh)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"重新加载" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    [self setImage:imageView
         labelText:@"没有网络哦，请检查下系统设置吧。"
     labelYPadding:10
            button:btn
       btnYPadding:20];

}

- (void)refresh{
    SafeCallSelector(delegate, @selector(refreshBtnClicked));
}

@end