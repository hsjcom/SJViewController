//
//  CLLRefreshHeadController.h
//  RefreshLoadView
//
//  Created by chuliangliang on 14-6-12.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLLRefreshState) {
    CLLRefreshStatePulling   = 0,
    CLLRefreshStateNormal    = 1,
    CLLRefreshStateLoading   = 2,
    CLLRefreshStateStopped   = 3,
};

typedef NS_ENUM(NSInteger, CLLLoadMoreState) {
    CLLLoadMoreStateNormal    = 10,
    CLLLoadMoreStateLoading   = 11,
    CLLLoadMoreStateStopped   = 12,
};

typedef NS_ENUM(NSInteger, CLLRefreshViewLayerType) {
    CLLRefreshViewLayerTypeOnScrollViews = 0,
    CLLRefreshViewLayerTypeOnSuperView = 1,
};


@protocol CLLRefreshHeadControllerDelegate <NSObject>
@required /* 必须协议*/
//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////--下拉刷新相关方法--//////////////////////////////////////////////
/**
 * 1 、下拉开始刷新
 *
 **/
- (void)beginPullDownRefreshing;

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////--上拉加载更多相关方法--///////////////////////////////////////////

/**
 * 2、上拉加载更多
 **/
- (void)beginPullUpLoading;

@optional /*可选协议*/
/**
 *  1、标识下拉刷新是UIScrollView的子view，还是UIScrollView父view的子view
 *
 *  @return 如果没有实现该delegate方法，默认是scrollView的子View，为CLLRefreshViewLayerTypeOnScrollViews
 **/
- (CLLRefreshViewLayerType)refreshViewLayerType;

/**
 *  2、UIScrollView的控制器是否保留iOS7新的特性，意思是：tablView的内容是否可以显示导航条后面
 *
 *  @return 如果不实现该delegate方法，默认是不支持的
 **/
- (BOOL)keepiOS7NewApiCharacter;

/**
 * 3、下拉刷新
 **/
- (BOOL)canPullDownRefreshed;

/**
 * 4、上拉更多
 **/
- (BOOL)canPullUpLoadMore;

@end


#import "CLLRefreshHeadController.h"

@interface CLLRefreshHeadController : NSObject

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL pullDownRefreshing;

/*
 * 是否上拉预加载
 * default：NO
 * by Soldier
 */
@property (nonatomic, assign) BOOL preloadEnable;

/*
 * 上拉更多滚动时是否加载
 * default：NO 滚动时不加载，滚动停止时才加载； YES 滚动时也可加载
 * by Soldier
 */
@property (nonatomic, assign) BOOL draggingNeedLoadMore;

/*
 * 上拉更多是否需要 scrollView.contentSize.height >= scrollView.height （用的较少）
 * default：NO scrollView.contentSize.height >= scrollView.height 才可上拉；
 *          YES  scrollView.contentSize.height > 44 即可上拉
 * by Soldier
 */
@property (nonatomic, assign) BOOL contentHeightLimitLoadMore;
@property (nonatomic, assign) CGFloat contentHeightLimitLoadMoreOffset;

/**
 *  上拉更多结束时，contentInset.bottom是否有值，没值时会回弹，有值露出底部的一小块不回弹
 *  default:NO 即有上拉刷新时有值  NO contentInset.bottom值为0   YES  contentInset.bottom值为CLLRefreshFooterViewHeight
 */
@property (nonatomic, assign) BOOL loadMoreHaveBottomInset;

- (id)initWithScrollView:(UIScrollView *)scrollView viewDelegate:(id <CLLRefreshHeadControllerDelegate>)delegate;

//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////--下拉刷新相关方法--//////////////////////////////////////////////
/**
 *  外部手动启动下拉加载的方法，例如 第一次进来 tableview自动下拉刷新
 */
- (void)startPullDownRefreshing;

/**
 *  停止下拉刷新的方法
 */
- (void)endPullDownRefreshing;

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////--上拉加载更多相关方法--///////////////////////////////////////////

/**
 *  停止上拉加载更多的方法
 */
- (void)endPullUpLoading;

@end
