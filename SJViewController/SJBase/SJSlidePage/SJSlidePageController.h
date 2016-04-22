//
//  SJSlidePageController.h
//
//
//  Created by Soldier on 16/4/1.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "SJModelViewController.h"
#import "SJSlidePageModel.h"
#import "FDSlideBar.h"
#import "SJSlideTabItem.h"


@protocol SJSlidePageDelegate <NSObject>

- (void)updatePageModel:(SJSlidePageModel *)model;

- (void)scrollWithContentOffsetY:(CGFloat)contentOffsetY offset:(CGFloat)offset; // offset 其它参数

- (void)updateContentOffset:(CGFloat)contentOffsetY;

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

@end
