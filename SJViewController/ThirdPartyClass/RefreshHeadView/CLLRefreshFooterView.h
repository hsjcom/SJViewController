//
//  CLLRefreshFooterView.h
//  RefreshLoadView
//
//  Created by chuliangliang on 14-12-26.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CLLRefreshFooterViewHeight 40

@interface CLLRefreshFooterView : UIView

//刷新操作提示
@property (nonatomic, strong)UILabel *statusLabel;

//刷新时间
@property (nonatomic, strong)UIActivityIndicatorView *indicatorView;

- (void)resetView;


@end
