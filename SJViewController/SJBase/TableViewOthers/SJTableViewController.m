//
//  SJTableViewController.m
//  SoldierViewController
//
//  Created by Soldier on 15-2-2.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJTableViewController.h"
#import "SJTableViewCell.h"
#import "CLLRefreshHeadView.h"

@implementation SJTableViewOverlayView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [self.delegate overlayView:self didHitTest:point withEvent:event];
}

@end





@interface SJTableViewController ()<SJTableViewOverlayViewDelegate>

/**
 *  侧滑Cell相关
 */
@property (nonatomic, strong) SJTableViewCell *cellDisplayingMenuOptions;
@property (nonatomic, strong) SJTableViewOverlayView *overlayView;
@property (nonatomic, assign) BOOL customEditing; //正在编辑中
@property (nonatomic, assign) BOOL customEditingAnimationInProgress; //侧滑的动画正在进行中
@end




@implementation SJTableViewController

@synthesize tableView = _tableView;
@synthesize loadMoreEnable = _loadMoreEnable;
@synthesize loadRefreshEnable = _loadRefreshEnable;

- (void)dealloc {
    [self setDataSource:nil];
    [self setTableView:nil];
    [self setRefreshControll:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (id)initWithQuery:(NSDictionary *)query {
    self = [super initWithQuery:query];
    if (self) {
        self.page = 1;
        self.lastItemId = @"";
        self.items = [NSMutableArray arrayWithCapacity:0];
        self.pullLoadType = PullDefault;
        
        _loadMoreEnable = YES;
        _loadRefreshEnable = YES;
    }
    return self;
}

- (CLLRefreshHeadController *)refreshControll {
    if (!_refreshControll) {
        _refreshControll = [[CLLRefreshHeadController alloc] initWithScrollView:self.tableView viewDelegate:self];
        
        _refreshControll.preloadEnable = [self preloadEnable];
        _refreshControll.draggingNeedLoadMore = [self draggingNeedLoadMore];
    }
    
    //不要放上边的创建里面，放这边，才能实时获取
    _refreshControll.loadMoreHaveBottomInset = [self loadMoreHaveBottomInset];
    return _refreshControll;
}

/*
 * 是否上拉预加载
 * default：NO
 */
- (BOOL)preloadEnable {
    return NO;
}

/*
 * 上拉更多滚动时是否加载
 * default：NO 滚动时不加载，滚动停止时才加载； YES 滚动时也可加载
 */
- (BOOL)draggingNeedLoadMore {
    return YES;
}

/*
 *  上拉更多结束时， TableView的contentInset.bottom是否有值，没值时会回弹，有值露出底部的一小块不回弹
 *  default:_loadMoreEnable即有上拉刷新时有值  NO TableView的contentInset.bottom值为0   YES   TableView的contentInset.bottom值为CLLRefreshFooterViewHeight
 */
- (BOOL)loadMoreHaveBottomInset{
    return _loadMoreEnable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
    
    [self addSwipListener];
}

//侧滑监听
- (void)addSwipListener {
    if ([self canSwipeCellToShowMenuView]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellContextMenuDidHide:) name:SJSwipeTableViewCellDidHideContextMenu object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellContextMenuDidShow:) name:SJSwipeTableViewCellDidShowContextMenu object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellContextMenuWillHide:) name:SJSwipeTableViewCellWillHideContextMenu object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellContextMenuWillShow:) name:SJSwipeTableViewCellWillShowContextMenu object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellContextMenuDidSelect:) name:SJSwipeTableViewCellMenuDidSelectItem object:nil];
        
        self.customEditing = self.customEditingAnimationInProgress = NO;
    }
}

- (UITableView *)tableView{
    if (nil == _tableView){
        _tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame]];
        _tableView.backgroundColor = [self backgroundColor];
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (CGRect)tableViewFrame{
    CGRect rect = self.view.bounds;
    return rect;
}

- (void)setDataSource:(id <SJTableViewDataSource>)dataSource{
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        _tableView.dataSource = _dataSource;
        [_tableView reloadData];
    }
}


- (void)didFinishLoad:(SJHTTPRequest *)request {
    [super didFinishLoad:request];
}

- (void)didFailLoadWithError:(SJHTTPRequest *)request {
    if (self.pullLoadType == PullUpLoadMore) {
        self.page--;
    }
    [super didFailLoadWithError:request];
}

- (void)onDataUpdated{
    [super onDataUpdated];
    
    [self createDataSource];
    
    [self handleLoadMoreEnable];
    [self handleWhenNoneData];
    
    [self setPullEndStatus];
}

- (void)onLoadFailed {
    [super onLoadFailed];
    [self setPullFailedStatus];
}

- (void)setPullEndStatus {
    if (self.pullLoadType == PullUpLoadMore) {
        [self endLoadMore];
    }else {
        [self performSelector:@selector(endRefresh) withObject:nil afterDelay:0.62];
    }
}

- (void)setPullFailedStatus{
    [self setPullEndStatus];
}

- (void)createDataSource {
    
}

- (void)handleLoadMoreEnable {
    if (self.items.count < 12 || self.newItemsCount <= 0) {
        [self setLoadMoreEnable:NO];
    }else{
        [self setLoadMoreEnable:YES];
    }
}

//如果无数据则进行处理
- (void)handleWhenNoneData{
    
}

- (void)setLoadMoreEnable:(BOOL)loadMoreEnable{
    _loadMoreEnable = loadMoreEnable;
}

- (void)setLoadRefreshEnable:(BOOL)loadRefreshEnable{
    _loadRefreshEnable = loadRefreshEnable;
}

- (void)endRefresh{
    if (self.pullLoadType != PullUpLoadMore) {
        self.pullLoadType = PullDefault;
    }
    [self.refreshControll endPullDownRefreshing];
}

- (void)endLoadMore{
    self.pullLoadType = PullDefault;
    [self.refreshControll endPullUpLoading];
    self.isPullingUp = NO;
}

//cell 点击跳转方法
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didBeginDragging{
}

- (void)didEndDragging{
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id <SJTableViewDataSource> dataSource = (id <SJTableViewDataSource>) tableView.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:tableView cellClassForObject:object];
    return [cls tableView:tableView rowHeightForObject:object];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id <SJTableViewDataSource> dataSource = (id <SJTableViewDataSource>) tableView.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    [self didSelectObject:object atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark -



#pragma mark - CLLRefreshHeadContorllerDelegate

- (CLLRefreshViewLayerType)refreshViewLayerType{
    return CLLRefreshViewLayerTypeOnScrollViews;
}

- (BOOL)keepiOS7NewApiCharacter{
//    if (!self.navigationController)
//        return NO;
//    BOOL keeped = [[[UIDevice currentDevice] systemVersion] integerValue] >= 7.0;
//    return keeped;
    
    //tableview.top 已设置，忽略
    return NO;
}

//controller直接调用自动下拉刷新
- (void)autoPullDown{
    [self.refreshControll startPullDownRefreshing];
    self.tableView.contentOffset = CGPointMake(0, -(CLLDefaultRefreshTotalPixels));
    [self refreshForNewData];
}

//更新了新数据
- (void)refreshForNewData {
    self.pullLoadType = PullDownRefresh;
    self.page = 1;
    self.lastItemId = @"";
    [self createModel];
}

- (void)beginPullDownRefreshing{
    [self refreshForNewData];
}

- (void)beginPullUpLoading{
    self.isPullingUp = YES;
    self.pullLoadType = PullUpLoadMore;
    self.page ++;
    [self createModel];
}

- (BOOL)canPullDownRefreshed{
    return _loadRefreshEnable;
}

- (BOOL)canPullUpLoadMore{
    return _loadMoreEnable;
}

#pragma mark -


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self didBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self didEndDragging];
}

#pragma mark - HBErrorViewDelegate

- (void)refreshBtnClicked{
    [self refreshForNewData];
}

- (void)tabClickrefreshData {
    if (self.isLoading) {
        return;
    }
    [self autoPullDown];
}


#pragma mark - cell侧滑相关

//子类重写
- (BOOL)canSwipeCellToShowMenuView{
    return NO;
}

- (void)cellContextMenuDidHide:(NSNotification *)note{
    //    HBTableViewCell *cell = note.object;
    self.customEditing = NO;
    self.customEditingAnimationInProgress = NO;
}

- (void)cellContextMenuDidShow:(NSNotification *)note {
    SJTableViewCell *cell = note.object;
    
    self.cellDisplayingMenuOptions = cell;
    self.customEditing = YES;
    self.customEditingAnimationInProgress = NO;
}

- (void)cellContextMenuWillHide:(NSNotification *)note{
    self.customEditingAnimationInProgress = YES;
}

- (void)cellContextMenuWillShow:(NSNotification *)note{
    self.customEditingAnimationInProgress = YES;
}

- (void)cellContextMenuDidSelect:(NSNotification *)note {
    SJTableViewCell *cell = note.object;
    NSInteger index = [note.userInfo[SJTableViewCellSwipeMenuItemIndexKey] integerValue];
    [self tableViewCell:cell didSelectMenuViewItemIndex:index];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView cellForRowAtIndexPath:indexPath] == self.cellDisplayingMenuOptions && [self canSwipeCellToShowMenuView]) {
        [self hideMenuOptionsAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)hideMenuOptionsAnimated:(BOOL)animated {
    __weak SJTableViewController *weakSelf = self;
    [self.cellDisplayingMenuOptions setMenuOptionsViewHidden:YES animated:animated completionHandler:^{
        weakSelf.customEditing = NO;
    }];
}

- (void)setCustomEditing:(BOOL)customEditing {
    if (_customEditing != customEditing) {
        _customEditing = customEditing;
        self.tableView.scrollEnabled = !customEditing;
        if (customEditing) {
            if (!_overlayView) {
                _overlayView = [[SJTableViewOverlayView alloc] initWithFrame:self.view.bounds];
                _overlayView.backgroundColor = [UIColor clearColor];
                _overlayView.delegate = self;
            }
            self.overlayView.frame = self.view.bounds;
            [self.view addSubview:_overlayView];
            if (self.shouldDisableUserInteractionWhileEditing) {
                for (UIView *view in self.tableView.subviews) {
                    if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                        view.userInteractionEnabled = NO;
                    }
                }
            }
        } else {
            self.cellDisplayingMenuOptions = nil;
            [self.overlayView removeFromSuperview];
            
            for (UIView *view in self.tableView.subviews) {
                if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                    view.userInteractionEnabled = YES;
                }
            }
        }
    }
}

- (UIView *)overlayView:(SJTableViewOverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    BOOL shouldIterceptTouches = YES;
    // 坐标的相关转换
    CGPoint location = [self.view convertPoint:point fromView:view];
    CGRect frame = CGRectMake(self.cellDisplayingMenuOptions.left - self.tableView.contentOffset.x, self.cellDisplayingMenuOptions.top - self.tableView.contentOffset.y, self.cellDisplayingMenuOptions.width, self.cellDisplayingMenuOptions.height);
    CGRect rect = [self.view convertRect:frame toView:self.view];
    // 判断点击的地方 是否在当前侧滑的cell，如果是 拦截事件的传递，直接传递到cell，如果否，则继续传递到下一个响应者做相应的处理，即（HBTableViewOverlayView——>self.view）
    shouldIterceptTouches = CGRectContainsPoint(rect, location);
    if (!shouldIterceptTouches) {
        [self hideMenuOptionsAnimated:YES];
    }
    return (shouldIterceptTouches) ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
}

- (void)tableViewCell:(SJTableViewCell *)cell didSelectMenuViewItemIndex:(NSInteger)index{
    /*
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row > self.items.count) {
        return;
    }
    if (index == 0) { //删除
        [self.items removeObjectAtIndex:indexPath.row];
    }
    
    [self createDataSource];
     */
}


@end
