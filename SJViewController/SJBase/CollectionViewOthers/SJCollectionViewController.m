//
//  SJCollectionViewController.m
//  
//
//  Created by Soldier on 15-2-9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJCollectionViewController.h"
#import "SJCollectionViewCell.h"
#import "SJCollectionViewHeaderView.h"
#import "SJCollectionViewFooterView.h"
#import "SJCollectionViewLayout.h"
#import "CLLRefreshHeadView.h"

@implementation SJCollectionViewController

#pragma mark  ========================        Init Data           ========================
- (void)dealloc {
    [self setDataSource:nil];
    [self setCollectionView:nil];
    [self setRefreshControll:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.page = 1;
        self.items = [NSMutableArray arrayWithCapacity:0];
        self.pullLoadType = PullDefault;
        
        _loadMoreEnable = YES;
        _loadRefreshEnable = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self collectionView];
    [self setCollectionLayout];
}

- (void)setDataSource:(id <SJCollectionViewDataSource>)dataSource{
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        _collectionView.dataSource = _dataSource;
        [_collectionView reloadData];
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

- (void)handleWhenLessOnePage {
    
}

//controller直接调用自动下拉刷新
- (void)autoPullDown{
    [self.refreshControll startPullDownRefreshing];
    _collectionView.contentOffset = CGPointMake(0, -(CLLDefaultRefreshTotalPixels));
    [self refreshForNewData];
}

//更新了新数据
- (void)refreshForNewData {
    self.pullLoadType = PullDownRefresh;
    self.page = 1;
    [self createModel];
}

#pragma mark  ========================          Init View         ========================
- (CLLRefreshHeadController *)refreshControll {
    if (!_refreshControll) {
        _refreshControll = [[CLLRefreshHeadController alloc] initWithScrollView:self.collectionView viewDelegate:self];
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
 * default:YES  NO 滚动时不加载，滚动停止时才加载； YES 滚动时也可加载
 */
- (BOOL)draggingNeedLoadMore {
    return YES;
}

/*
 *  上拉更多结束时， CollectionView的contentInset.bottom是否有值，没值时会回弹，有值露出底部的一小块不回弹
 *  default:_loadMoreEnable即有上拉刷新时有值  NO CollectionView的contentInset.bottom值为0   YES   CollectionView的contentInset.bottom值为CLLRefreshFooterViewHeight
 */
-(BOOL)loadMoreHaveBottomInset{
    return _loadMoreEnable;
}

#pragma mark- collectionView

- (UICollectionView *)collectionView {
    if (nil == _collectionView){
        SJCollectionViewLayout *layout = [[SJCollectionViewLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:[self collectionViewFrame] collectionViewLayout:layout];
        _collectionView.backgroundColor = [self backgroundColor];
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        [self collectionViewRegisterCellClassAndReuseIdentifier];
    }
    return _collectionView;
}


//初始化注册cell&Identifier（多种）
- (void)collectionViewRegisterCellClassAndReuseIdentifier {
    [_collectionView registerClass:[SJCollectionViewCell class] forCellWithReuseIdentifier:@"SJCollectionViewCell"];
    [self.collectionView registerClass:[SJCollectionViewHeaderView class]  forSupplementaryViewOfKind:SJCollectionViewHeader withReuseIdentifier:@"SJCollectionViewHeader"];
    [self.collectionView registerClass:[SJCollectionViewFooterView class]  forSupplementaryViewOfKind:SJCollectionViewFooter withReuseIdentifier:@"SJCollectionViewFooter"];
}

- (CGRect)collectionViewFrame {
    CGFloat height = UI_SCREEN_HEIGHT - [self selfNavigatorHeight] - 20.f;
    return CGRectMake(0, 0, UI_SCREEN_WIDTH, height);
}


#pragma mark- UICollectionViewDelegateFlowLayout
- (void)setCollectionLayout{
    NSMutableArray *numOfRowsMuti = [self numOfRowsMuti];
    if (!numOfRowsMuti) {
        numOfRowsMuti = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedLong:[self numOfRows]]];
    }
    self.layout.numberOfItemsPerLines = numOfRowsMuti;
    
    NSMutableArray *XPaddingMuti = [self XPaddingMuti];
    if (!XPaddingMuti) {
        XPaddingMuti = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedLong:[self XPadding]]];
    }
    self.layout.XSpacings = XPaddingMuti;
    
    NSMutableArray *YPaddingMuti = [self YPaddingMuti];
    if (!YPaddingMuti) {
        YPaddingMuti = [NSMutableArray arrayWithObject:[NSNumber numberWithUnsignedLong:[self YPadding]]];
    }
    self.layout.YSpacings = YPaddingMuti;

    NSMutableArray *layoutEdgeInsetsMuti = [self layoutEdgeInsetsMuti];
    if (!layoutEdgeInsetsMuti) {
        NSString *string = NSStringFromUIEdgeInsets([self layoutEdgeInsets]);
        layoutEdgeInsetsMuti = [NSMutableArray arrayWithObject:string];
    }
    self.layout.sectionInsets = layoutEdgeInsetsMuti;
}

#pragma mark- default one section
//设置collectionView的内容有几列
- (NSUInteger)numOfRows{
    return 2;
}

//列间距
- (CGFloat)XPadding{
    return 5.f;
}

//行间距
- (CGFloat)YPadding{
    return 5.f;
}

//设置collectionView的前后左右的间距
- (UIEdgeInsets)layoutEdgeInsets{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - muti sections
//设置collectionView的内容有几列
- (NSMutableArray *)numOfRowsMuti{
    return nil;
}

//列间距
- (NSMutableArray *)XPaddingMuti{
    return nil;
}

//行间距
- (NSMutableArray *)YPaddingMuti{
    return nil;
}

- (NSMutableArray *)layoutEdgeInsetsMuti{
    return nil;
}


- (SJCollectionViewLayout *)layout
{
    return (id)self.collectionView.collectionViewLayout;
}


#pragma mark  ========================         Func          ========================
//cell 点击跳转方法
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didBeginDragging{
    
}

- (void)didEndDragging{
}

- (void)handleLoadMoreEnable {
    if (self.items.count < 12 || self.newItemsCount <= 0) {
        [self setLoadMoreEnable:NO];
    }else{
        [self setLoadMoreEnable:YES];
    }
}

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

#pragma mark -


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    id <SJCollectionViewDataSource> dataSource = (id <SJCollectionViewDataSource>) collectionView.dataSource;
    id object = [dataSource collectionView:collectionView objectForRowAtIndexPath:indexPath];
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

- (void)beginPullDownRefreshing{
    self.pullLoadType = PullDownRefresh;
    self.page = 1;
    [self createModel];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self didBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self didEndDragging];
}

- (void)tabClickrefreshData {
    if (self.isLoading) {
        return;
    }
    [self autoPullDown];
}

@end
