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


@implementation SJTableViewController
@synthesize swipCell = _swipCell;
@synthesize swipCellItem = _swipCellItem;
@synthesize tableView = _tableView;
@synthesize loadMoreEnable = _loadMoreEnable;
@synthesize loadRefreshEnable = _loadRefreshEnable;

- (void)dealloc {
    [self setDataSource:nil];
    [self setTableView:nil];
    [self setRefreshControll:nil];
    
    _upCoverCtl = nil;
    _downCoverCtl = nil;
    
    _swipCell = nil;
    _swipCellItem = nil;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithQuery:(NSDictionary *)query {
    self = [super initWithQuery:query];
    if (self) {
        self.page = 1;
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
-(BOOL)loadMoreHaveBottomInset{
    return _loadMoreEnable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableView];
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
    
    [self handleWhenLessOnePage];
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

- (void)handleWhenLessOnePage {
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

#pragma mark  ========================          CoverView         ========================

- (void)addCoverOnTableView {
    _upCoverCtl = [[UIControl alloc] initWithFrame:CGRectZero];
    [_upCoverCtl addTarget:self action:@selector(touchToRemoveCoverOnTableView) forControlEvents:UIControlEventAllTouchEvents];
    [self.tableView.superview addSubview:_upCoverCtl];
    
    _downCoverCtl = [[UIControl alloc] initWithFrame:CGRectZero];
    [_downCoverCtl addTarget:self action:@selector(touchToRemoveCoverOnTableView) forControlEvents:UIControlEventAllTouchEvents];
    [self.tableView.superview addSubview:_downCoverCtl];
    
    [self setCoverOnTableViewFrame];
    
    _swipContentOffSet = self.tableView.contentOffset.y;
}

- (void)setCoverOnTableViewFrame {
    //因为_swipCell 会被重用，所以_swipCell不可完全信任
    if (_swipCell.object != _swipCellItem) {
        return;
    }
    
    CGFloat tableTop = self.tableView.top;
    CGRect cellFrame = [self.tableView convertRect:_swipCell.frame toView:self.tableView.superview];
    
    
    if (cellFrame.origin.y + cellFrame.size.height < tableTop) {
        _upCoverCtl.frame = CGRectZero;
    }
    else {
        _upCoverCtl.frame = CGRectMake(0, tableTop, UI_SCREEN_WIDTH , cellFrame.origin.y - tableTop);
    }
    
    
    CGFloat bottomTop = cellFrame.origin.y + cellFrame.size.height;
    if (cellFrame.origin.y > self.tableView.bottom) {
        _downCoverCtl.frame = CGRectZero;
    }
    else {
        _downCoverCtl.frame = CGRectMake(0, bottomTop, UI_SCREEN_WIDTH, self.tableView.bottom - bottomTop);
    }
}

- (void)touchToRemoveCoverOnTableView {
    [_upCoverCtl removeFromSuperview];
    [_downCoverCtl removeFromSuperview];
    
    [self clickToOutEditForCellReset];
}

- (void)clickToOutEditForCellReset {

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
    if (_swipCell) {
        [self setCoverOnTableViewFrame];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self didBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self didEndDragging];
}

#pragma mark HBErrorViewDelegate
- (void)refreshBtnClicked{
    [self refreshForNewData];
}

- (void)tabClickrefreshData {
    if (self.isLoading) {
        return;
    }
    [self autoPullDown];
}

@end
