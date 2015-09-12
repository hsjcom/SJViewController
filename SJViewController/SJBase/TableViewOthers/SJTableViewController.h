//
//  SJTableViewController.h
//  SoldierViewController
//
//  Created by Soldier on 15-2-2.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJModelViewController.h"
#import "CLLRefreshHeadController.h"
#import "SJTableViewDataSource.h"
#import "UITableView+Add.h"

@class SJTableViewCell;

@interface SJTableViewController : SJModelViewController<UITableViewDelegate, CLLRefreshHeadControllerDelegate>{
    SJTableViewCell __weak *_swipCell;
    NSObject __weak *_swipCellItem;
    CGFloat _swipContentOffSet;
    UIControl *_upCoverCtl;  //对处于侧滑删除状态的cell以上view添加蒙层以点击撤销删除状态
    UIControl *_downCoverCtl;//同上，cell以下view添加蒙层
    UITableView *_tableView;
}

@property(nonatomic, strong) id <SJTableViewDataSource> dataSource;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, assign) PullLoadType pullLoadType;
@property(nonatomic, assign) NSInteger newItemsCount;
@property(nonatomic, assign) int page;
@property(nonatomic, assign) BOOL loadMoreEnable;
@property(nonatomic, weak)   UITableViewCell *swipCell;
@property(nonatomic, weak)   NSObject *swipCellItem;
@property(nonatomic, assign) BOOL loadRefreshEnable;
@property (nonatomic, strong) CLLRefreshHeadController *refreshControll;


- (UITableView *)tableView;

- (CGRect)tableViewFrame;

- (void)createDataSource;

//controller直接调用自动下拉刷新
- (void)autoPullDown;

//更新了新数据
- (void)refreshForNewData ;

//下拉刷新回调
- (void)beginPullDownRefreshing;

//上拉刷新回调
- (void)beginPullUpLoading;

- (void)setPullEndStatus;

- (void)setPullFailedStatus;

//初始化：控制是否下拉刷新
- (BOOL)canPullDownRefreshed;

//初始化：是否上拉更多
- (BOOL)canPullUpLoadMore;

- (void)didBeginDragging;

- (void)didEndDragging;

//控制是否下拉刷新
- (void)setLoadRefreshEnable:(BOOL)loadRefreshEnable;

//每页item数少于limit处理方法
- (void)handleWhenLessOnePage;

//如果无数据则进行处理
- (void)handleWhenNoneData;

- (void)addCoverOnTableView;

- (void)touchToRemoveCoverOnTableView;

//cell 点击跳转方法
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

/*
 * 是否上拉预加载
 * default：NO
 */
- (BOOL)preloadEnable;

/*
 * 上拉更多滚动时是否加载
 * default:YES   NO 滚动时不加载，滚动停止时才加载； YES 滚动时也可加载
 */
- (BOOL)draggingNeedLoadMore;

/*
 *  上拉更多结束时，TableView的contentInset.bottom是否有值，没值时会回弹，有值露出底部的一小块不回弹
 *  default:_loadMoreEnable即有上拉刷新时有值  NO TableView的contentInset.bottom值为0   YES   TableView的contentInset.bottom值为CLLRefreshFooterViewHeight
 */
- (BOOL)loadMoreHaveBottomInset;


@end
