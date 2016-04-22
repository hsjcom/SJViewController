//
//  SJSlidePageController.m
//
//
//  Created by Soldier on 16/4/1.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "SJSlidePageController.h"
#import "SJSlidePageCell.h"
#import <objc/runtime.h>

@interface SJSlidePageController () {
    BOOL _isClickSlideBar; //通过点击切换页面
}

@end





@implementation SJSlidePageController

- (id)initWithQuery:(NSDictionary *)query{
    self = [super initWithQuery:query];
    if (self) {
        self.pageIndex = 0;
        _isClickSlideBar = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self slideBar];
    [self mainColllectionView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self cellControllerViewDisAppear];
    [self dismissAllVCKeyBoard];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self cellControllerViewAppear];
}

- (UICollectionView *)mainColllectionView {
    if (!_mainColllectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
        flowLayout.itemSize = [self colllectionViewFrame].size;//item的大小
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.minimumLineSpacing = 0.0;
        
        _mainColllectionView = [[UICollectionView alloc] initWithFrame:[self colllectionViewFrame] collectionViewLayout:flowLayout];
        _mainColllectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_mainColllectionView];
        
        [_mainColllectionView registerClass:[SJSlidePageCell class] forCellWithReuseIdentifier:@"HBSlidePageCell"];
        _mainColllectionView.showsVerticalScrollIndicator = NO;
        _mainColllectionView.showsHorizontalScrollIndicator = NO;
        _mainColllectionView.pagingEnabled = YES;
        _mainColllectionView.dataSource = self;
        _mainColllectionView.delegate = self;
    }
    return _mainColllectionView;
}

- (CGRect)colllectionViewFrame {
    return CGRectMake(0, self.slideBar.height, self.view.width, self.view.height - self.slideBar.height);
}

- (void)registerCellIdentifierForView:(UICollectionView *)collectionView cellClass:(Class)cellClass{
    NSString *className = [StringUtil className:cellClass];
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:className];
}

- (FDSlideBar *)slideBar {
    if (!_slideBar) {
        _slideBar = [[FDSlideBar alloc] initWithFrame:[self slideBarFrame]];
        _slideBar.backgroundColor = [UIColor whiteColor];
        _slideBar.itemColor = COLOR_TEXT_2;
        _slideBar.itemSelectedColor = COLOR_TEXT_1;
        _slideBar.sliderColor = RGBCOLOR(255, 200, 17);
        [_slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
            [self.mainColllectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            
            _isClickSlideBar = YES;
        }];
        [self.view addSubview:_slideBar];
        
        UIView *liner = [[UIView alloc] initWithFrame:CGRectMake(0, _slideBar.height - 0.5, _slideBar.width, 0.5)];
        liner.backgroundColor = COLOR_TEXT_2;
        [_slideBar addSubview:liner];
    }
    return _slideBar;
}

- (CGRect)slideBarFrame {
    return CGRectMake(0, 0, UI_SCREEN_WIDTH, 40);
}

- (void)setupSlideBarTabs:(NSArray <SJSlideTabItem *> *)tabItems {
    NSArray *tabTitles = [tabItems valueForKeyPath:@"tabName"];
    _slideBar.itemsTitle = tabTitles;
}

- (void)setTabItems:(NSMutableArray *)tabItems {
    if (!_tabItems) {
        _tabItems = [NSMutableArray new];
    }
    if (tabItems.count <= 0) {
        return;
    }
    
    _tabItems = tabItems;
    [self.mainColllectionView reloadData];
    
    [self setupSlideBarTabs:_tabItems];
}

#pragma mark - UICollectionViewDataSource

/**
 * UICollectionViewDataSource 根据需要及数据模型在子类重写
 */

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _tabItems.count > 0 ? _tabItems.count : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self pageIndex:indexPath.row];
    
    /*
    HBSlidePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HBSlidePageCell" forIndexPath:indexPath];
    [cell initWithQuery:[self controllersInitialQuary] delegate:self index:self.pageIndex];
    [cell reloadDataWithMode:[self reloadModelFromMianModel]];
    */
    
    Class cellClass = [self cellClass];
    const char *className = class_getName(cellClass);
    
    [self registerCellIdentifierForView:collectionView cellClass:cellClass];
    
    NSString *identifier = [[NSString alloc] initWithBytesNoCopy:(char *) className
                                                          length:strlen(className)
                                                        encoding:NSASCIIStringEncoding freeWhenDone:NO];
    
    UICollectionViewCell *cell = (UICollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[cellClass alloc] init];
    }
    
    if ([cell isKindOfClass:[SJSlidePageCell class]]) {
        [(SJSlidePageCell *)cell initWithQuery:[self controllersInitialQuary] delegate:self index:self.pageIndex];
        [(SJSlidePageCell *)cell reloadDataWithMode:[self reloadModelFromMianModel]];
    }
    
    [cell setNeedsLayout];
    
    if (_isClickSlideBar) { //通过点击SlideBar切换页面 layoutSubviews
        [cell layoutSubviews];
    }
    _isClickSlideBar = NO;
    
    [self dismissAllVCKeyBoard];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[SJSlidePageCell class]]) {
        SJSlidePageCell *sCell = (SJSlidePageCell *)cell;
        if (sCell.controller) {
            [sCell.controller viewWillDisappear:YES];
            [sCell.controller viewDidDisappear:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

/**
 * 子类重写 UIScrollViewDelegate 需要super方法
 */

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint tempPoint = CGPointMake(scrollView.contentOffset.x, 0);
    NSIndexPath *indexPath = [self.mainColllectionView indexPathForItemAtPoint:tempPoint];
    [self.slideBar selectSlideBarItemAtIndex:indexPath.row];
}

/*
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGPoint tempPoint = CGPointMake(scrollView.contentOffset.x, 0);
    NSIndexPath *indexPath = [self.mainColllectionView indexPathForItemAtPoint:tempPoint];
    HBSlidePageCell *cell = (HBSlidePageCell *)[self.mainColllectionView cellForItemAtIndexPath:indexPath];
    if (cell.controller.tableView.contentOffset.y > 0) {
        for (HBSlidePageModel *item in self.model.items) {
            if (item.pageIndex == cell.controller.pageIndex) {
                item.contentOffsetY = cell.controller.tableView.contentOffset.y;
                break;
            }
        }
    }
}
*/

/**
 * 设置controller初始化参数, 在子类重写
 */
- (NSDictionary *)controllersInitialQuary {
    if (self.tabItems.count <= 0) {
        return nil;
    }
    return nil;
}

/**
 * 设置Cell类, 在子类重写
 */
- (Class)cellClass {
    return [SJSlidePageCell class];
}

- (SJSlidePageModel *)model {
    if (!_model) {
        _model = [[SJSlidePageModel alloc] init];
        _model.pageIndex = 0;
    }
    return _model;
}

- (void)pageIndex:(NSInteger)index {
    self.pageIndex = index;
    self.model.pageIndex = index;
}

- (SJSlidePageModel *)reloadModelFromMianModel {
    for (SJSlidePageModel *item in self.model.items) {
        if (item.pageIndex == self.pageIndex) {
            return item;
        }
    }
    return nil;
}

- (void)layoutCellSubviews:(NSInteger)pageIndex {
    NSIndexPath *path = [NSIndexPath indexPathForRow:pageIndex inSection:0];
    SJSlidePageCell *cell = (SJSlidePageCell *)[self.mainColllectionView cellForItemAtIndexPath:path];
    if (cell) {
        [cell layoutSubviews];
    }
}

/**
 * 获取collectionView中当前controller
 */
- (SJViewController *)getCurrentCellController {
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.pageIndex inSection:0];
    SJSlidePageCell *cell = (SJSlidePageCell *)[self.mainColllectionView cellForItemAtIndexPath:path];
    if (cell) {
        if (cell.controller) {
            return cell.controller;
        }
    }
    return nil;
}

#pragma mark - HBSlidePageDelegate

- (void)updatePageModel:(SJSlidePageModel *)model {
    if (!model) {
        return;
    }
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (SJSlidePageModel *item in self.model.items) {
        if (item.pageIndex == model.pageIndex) {
            [tempArray addObject:item];
            break;
        }
    }
    [self.model.items removeObjectsInArray:tempArray];
    [self.model.items addObject:model];
}

- (void)updateContentOffset:(CGFloat)contentOffsetY{
    for (SJSlidePageModel *item in self.model.items) {
        if (item.pageIndex == self.pageIndex) {
            item.contentOffsetY = contentOffsetY;
        }
    }
}

/**
 * 根据需要在子类重写
 */
- (void)scrollWithContentOffsetY:(CGFloat)contentOffsetY offset:(CGFloat)offset {
    /* eg 1.
    if (contentOffsetY <= 0 || ABS(contentOffsetY) > 100) {
        return;
    }
    
    self.slideBar.top = - contentOffsetY;
    
    self.mainColllectionView.top = self.slideBar.height - contentOffsetY ;
    self.mainColllectionView.height = (self.view.height - self.slideBar.height) + contentOffsetY;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
    flowLayout.itemSize = CGSizeMake(self.view.width, self.mainColllectionView.height);
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    self.mainColllectionView.collectionViewLayout = flowLayout;
     */
    
    /* eg 2.
    // offset 1 下滑   0 上滑
    if (offset < 1) {
        if (self.slideBar.top > -100) {
            [self setSlideBarTop:100];
        }
    } else {
        if (self.slideBar.top < 0) {
            [self setSlideBarTop:0];
        }
    }
     */
}

/*
- (void)setSlideBarTop:(CGFloat)contentOffsetY {
    [UIView animateWithDuration:0.3 animations:^{
        self.slideBar.top = - contentOffsetY;
        self.mainColllectionView.top = self.slideBar.height - contentOffsetY;
    } completion:^(BOOL finished) {
    }];
    
    float durtion = contentOffsetY > 0 ? 0 : 0.3;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durtion * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mainColllectionView.height = (self.view.height - self.slideBar.height) + contentOffsetY;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
        flowLayout.itemSize = CGSizeMake(self.view.width, self.mainColllectionView.height);
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.minimumLineSpacing = 0.0;
        self.mainColllectionView.collectionViewLayout = flowLayout;
    });
}
*/

/**
 *取消controller所有键盘
 */
- (void)dismissAllVCKeyBoard {
    [self.mainColllectionView endEditing:YES];
}

- (void)cellControllerViewAppear{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.pageIndex inSection:0];
    SJSlidePageCell *cell = (SJSlidePageCell *)[self.mainColllectionView cellForItemAtIndexPath:path];
    if (cell) {
        if (cell.controller) {
            [cell.controller viewWillAppear:YES];
            [cell.controller viewDidAppear:YES];
        }
    }
}

- (void)cellControllerViewDisAppear{
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.pageIndex inSection:0];
    SJSlidePageCell *cell = (SJSlidePageCell *)[self.mainColllectionView cellForItemAtIndexPath:path];
    if (cell) {
        if (cell.controller) {
            [cell.controller viewWillDisappear:YES];
            [cell.controller viewDidDisappear:YES];
        }
    }
}


@end
