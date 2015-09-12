//
//  SJCollectionViewController.h
//
//
//  Created by Soldier on 15-2-9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJModelViewController.h"
#import "SJCollectionViewDataSource.h"
#import "CLLRefreshHeadController.h"

@interface SJCollectionViewController : SJModelViewController<CLLRefreshHeadControllerDelegate,  UICollectionViewDelegate>

//UICollectionViewDelegateFlowLayout
@property(nonatomic, strong) id <SJCollectionViewDataSource> dataSource;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) PullLoadType pullLoadType;
@property(nonatomic, assign) NSInteger newItemsCount;
@property(nonatomic, assign) int page;
@property(nonatomic, assign) BOOL loadMoreEnable;
@property(nonatomic, assign) BOOL loadRefreshEnable;
@property(nonatomic, strong) CLLRefreshHeadController *refreshControll;

- (UICollectionView *)collectionView;

- (void)setCollectionLayout;

- (CGRect)collectionViewFrame;

#pragma mark  - layout  

//设置collectionView的前后左右的间距
- (UIEdgeInsets)layoutEdgeInsets;

//设置collectionView的内容有几列
- (NSUInteger)numOfRows;

//列间距
- (CGFloat)XPadding;

//行间距
- (CGFloat)YPadding;


#pragma mark - muti custom

- (NSMutableArray *)layoutEdgeInsetsMuti;

//设置collectionView的内容有几列
- (NSMutableArray *)numOfRowsMuti;

//列间距
- (NSMutableArray *)XPaddingMuti;

//行间距
- (NSMutableArray *)YPaddingMuti;

#pragma mark - layout

- (void)createDataSource;

- (void)setPullEndStatus;

//初始化：控制是否下拉刷新
- (BOOL)canPullDownRefreshed;

//初始化：是否上拉更多
- (BOOL)canPullUpLoadMore;

//controller直接调用自动下拉刷新
- (void)autoPullDown;

- (void)didBeginDragging;

- (void)didEndDragging;

//控制是否上拉更多
- (void)setLoadMoreEnable:(BOOL)loadMoreEnable;

//控制是否下拉刷新
- (void)setLoadRefreshEnable:(BOOL)loadRefreshEnable;

//每页item数少于limit处理方法
- (void)handleWhenLessOnePage;

//如果无数据则进行处理
- (void)handleWhenNoneData;

//cell 点击跳转方法
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;


//初始化注册cell&Identifier（多种）
- (void)collectionViewRegisterCellClassAndReuseIdentifier;

/*
 * 是否上拉预加载
 * default：NO
 */
- (BOOL)preloadEnable;

/*
 * 上拉更多滚动时是否加载
 * default：NO 滚动时不加载，滚动停止时才加载； YES 滚动时也可加载
 */
- (BOOL)draggingNeedLoadMore;

/*
 *  上拉更多结束时， CollectionView的contentInset.bottom是否有值，没值时会回弹，有值露出底部的一小块不回弹
 *  default:_loadMoreEnable即有上拉刷新时有值  NO CollectionView的contentInset.bottom值为0   YES   CollectionView的contentInset.bottom值为CLLRefreshFooterViewHeight
 */
-(BOOL)loadMoreHaveBottomInset;

@end
