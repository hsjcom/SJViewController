//
//  SJSlidePageController.h
//
//
//  Created by Soldier on 16/4/1.
//  Copyright © 2016年 厦门海豹信息技术. All rights reserved.
//

#import "SJModelViewController.h"
#import "SJSlidePageModel.h"
#import "FDSlideBar.h"
#import "SJSlideTabItem.h"


@protocol SJSlidePageDelegate <NSObject>

@required

- (void)updatePageModel:(SJSlidePageModel *)model;

- (void)updateContentOffset:(CGFloat)contentOffsetY;

@optional

- (void)scrollWithContentOffsetY:(CGFloat)contentOffsetY offset:(CGFloat)offset; // offset 其它参数

- (void)itemControllBeginPullDownRefreshing; //tab Controller 下拉刷新回调

- (void)scrollViewDidScrollWithContentOffsetY:(CGFloat)contentOffsetY offset:(CGFloat)offset;


@end




/**
 * 横向滑动分页 SJSlidePageController
 * midel—>SJSlidePageModel cell->SJSlidePageCell
 */

@interface SJSlidePageController : SJModelViewController<UICollectionViewDataSource, UICollectionViewDelegate, SJSlidePageDelegate>

@property (nonatomic, strong) UICollectionView *mainColllectionView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) SJSlidePageModel *model;
@property (nonatomic, strong) FDSlideBar *slideBar;
@property (nonatomic, strong) NSMutableArray *tabItems;
@property (nonatomic, assign) BOOL isClickSlideBar; //通过点击切换页面

- (CGRect)slideBarFrame;

- (CGRect)colllectionViewFrame;

/**
 * 设置controller初始化参数, 在子类重写
 */
- (NSDictionary *)controllersInitialQuary;

/**
 * 设置Cell类, 在子类重写
 */
- (Class)cellClass;

/**
 *取消controller所有键盘
 */
- (void)dismissAllVCKeyBoard;

- (void)cellControllerViewAppear;

- (void)cellControllerViewDisAppear;

/**
 * 获取collectionView中当前controller
 */
- (SJViewController *)getCurrentCellController;

/**
 * 滑动到某个tab
 */
- (void)slideToTabWithIndex:(NSInteger)index;

/**
 * 点击某个tab的回调
 */
- (void)clickTapWithIndex:(NSInteger)index;

@end
