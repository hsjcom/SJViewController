//
//  HBErrorView.h
//  
//
//  Created by Shaojie Hong on 15/2/26.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "HBEmptyView.h"

@protocol HBErrorViewDelegate <NSObject>

//重新加载按钮点击事件
- (void)refreshBtnClicked;

@end

@interface HBErrorView : HBEmptyView

@property(nonatomic, weak)id<HBErrorViewDelegate> delegate;

@end