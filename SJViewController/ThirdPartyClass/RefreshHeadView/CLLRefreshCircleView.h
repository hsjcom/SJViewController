//
//  CLLRefreshCircleView.h
//  RefreshLoadView
//
//  Created by chuliangliang on 14-6-13.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CLLRefreshCircleView : UIView

//圆圈开始旋转时的offset （即开始刷新数据时）
@property (nonatomic, assign) CGFloat heightBeginToRefresh;

//offset的Y值
@property (nonatomic, assign) CGFloat offsetY;

/**
 *  说明
 *  isRefreshViewOnTableView
 *  YES:refreshView是tableView的子view
 *  NO:refreshView是tableView.superView的子view
 */
@property (nonatomic, assign) BOOL isRefreshViewOnTableView;

/**
 *  旋转的animation
 *
 *  @return animation
 */
+ (CABasicAnimation*)repeatRotateAnimation;

@end
