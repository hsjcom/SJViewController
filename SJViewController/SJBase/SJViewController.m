//
//  SJViewController.m
//
//
//  Created by Shaojie Hong on 15-1-28.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJViewController.h"
#import "HBProcessIndicator.h"
#import "SJTopTipView.h"
#import <objc/runtime.h>
#import "SJNavigationViewController.h"

@interface SJViewController ()

@end




@implementation SJViewController

@synthesize emptyView = _emptyView;

- (void)dealloc{
    _errorView.delegate = nil;
}

/**
 * controller 传参
 * by soldier
 */
- (id)initWithQuery:(NSDictionary *)query {
    self = [super init];
    if (self) {
        if (query) {
            self.query = query;
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 0);
    
    if([self isRootView] ){
//        UIImage *img = IsiOS7() ? [UIImage imageNamed:@"navBarBg64"] : [UIImage imageNamed:@"navBarBg44"];
//        [self.navigationController.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
        
        [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        RGBCOLOR(53, 53, 53), NSForegroundColorAttributeName,
                                        shadow, NSShadowAttributeName,
                                        [UIFont systemFontOfSize:17],
                                        NSFontAttributeName,
                                        nil]];
    }else{
        [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        RGBACOLOR(53, 53, 53, 0.5), NSForegroundColorAttributeName,
                                        shadow, NSShadowAttributeName,
                                        [UIFont systemFontOfSize:17],
                                        NSFontAttributeName,
                                        nil]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // ios 7 以上需要设置背景色后才可以支持 右滑动返回
    [self.view setBackgroundColor:[self backgroundColor]];
    
    // 设置后 UIview 的frame y就不是从navbar下开始
    if (IsiOS7()) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = StatusBarHeight;
    AppDelegate *app = (AppDelegate *)AppDelegateInstance;
    float tabBarHeight = app.tabBarController.tabBar.frame.size.height;
    if (![self isRootView]) {
        tabBarHeight = 0;
    }
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    viewBounds.size.height = UI_SCREEN_HEIGHT - tabBarHeight - topBarOffset - navBarHeight;
    
    self.view.bounds = viewBounds;
    
    [self constructBackBtn];
}

/**
 * 判断是否是5大首页
 */
- (BOOL)isRootView{
    return NO;
}

/**
 * 右滑返回， default YES
 */
- (BOOL)canDragBack {
    return YES;
}

/**
 * 创建返回 按钮  ios 6 7 区分
 */
- (void)constructBackBtn{
    /**
     * root 主界面 不出现 返回按钮
     */
    if ([self isRootView]){
        return;
    }
    
//    if (!IsiOS7() || self.presentBackBtn){
        self.navigationItem.backBarButtonItem.enabled = NO;
        
        //取 push 进来的view 的title
//        NSString *backTitle = @"返回";
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        NSInteger index = [viewControllers indexOfObject:self];
//        UIViewController *beforeVC = nil;
//        if (NSNotFound != index) {
//            index -= 1;
//            if (index >= 0) {
//                beforeVC = [viewControllers objectAtIndex:index];
//                backTitle = beforeVC.title;
//                if(backTitle.length > 4){
//                    backTitle = @"返回";
//                }
//            }
//        }
//        // 若有自定义 则用自定义的 文字
//        if ([self backButtonTilte]) {
//            backTitle = [self backButtonTilte];
//        }
    
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        CGSize navSize = CGSizeMake(10, 18);
//        UIImage *navImg = [UIImage imageNamed:@"navBackIndicatorImg"];
//        navImg = [ImageUtil zoomToSize:navImg size:navSize];
//        UIImageView *nav = [[UIImageView alloc] initWithImage:navImg];
//        nav.frame = CGRectMake(12, 13, navSize.width, navSize.height);
//        backTitleLabel = [ViewConstructUtil constructLabel:CGRectMake(30, 0, 80, 44) text:backTitle font:[UIFont systemFontOfSize:17] textColor:COLOR_TEXT_1];
//        [backTitleLabel setTextAlignment:NSTextAlignmentLeft];
//        [backBtn addSubview:nav];
//        [backBtn addSubview:backTitleLabel];
    
        [backBtn setImage:[UIImage imageNamed:@"navBackIndicatorImg"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"navBackIndicatorImg_hl"] forState:UIControlStateHighlighted];
        backBtn.frame = CGRectMake(10, 0, 44, 44);
        backBtn.backgroundColor = [UIColor clearColor];
        
        [backBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
        
        self.navigationItem.leftBarButtonItem = item;
//    }
}

/**
 * 自定义返回按钮 宽度
 */
- (CGFloat)setBackBtnWidth{
    return 110;
}

/**
 * 自定义下一页返回按钮 文字设置 若需要则重载
 */
- (NSString *)backButtonTilteOfNext{
    return nil;
}

/**
 * 返回方法,可自定义重写
 */
- (void)backView {
    SJNavigationViewController *navigationViewController = (SJNavigationViewController *)self.navigationController;
    [navigationViewController customPopViewController];
    
//    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 返回方法,可自定义重写,可以控制动画效果
 */
- (void)backView:(BOOL)animated{
   [self.navigationController popViewControllerAnimated:animated];
}

/**
 * 侧滑返回。点击返回 --都可自定义重写
 */
- (void)backViewForSideslip{
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 * 自定义返回按钮 文字设置 若需要则重载
 */
- (NSString *)backButtonTilte{
    return nil;
}

//!如果设置此方法，则iOS7以上侧滑功能会失效
- (void)addNavLeftBtn:(UIView *)btn {
    if (!btn) {
        return;
    }
    
    btn.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

/**
 * 导航栏右边按钮
 */
- (void)addNavRightBtn:(UIView *)btn {
    if (!btn) {
        return;
    }
    btn.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.rightBarButtonItem.width = IsiOS7() ? -15 : -5;
}

- (void)removeNavRightBtn {
    self.navigationItem.rightBarButtonItem = nil;
}

- (CGRect)rightBtnFrame {
    CGFloat width = 42, height = 44;
    return CGRectMake(0, 0, width, height);
}

- (UIColor *)rightNavigationItemColor {
    return RGBCOLOR(53, 53, 53);
}

- (UIColor *)rightNavigationItemHightLightColor {
    return RGBACOLOR(53, 53, 53, 0.5);
}

/**
 * 导航栏右按钮 文字按钮
 */
- (void)constructNavRightBtn:(NSString *)title action:(SEL)action width:(CGFloat)width {
    UIButton *navigationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navigationBtn.frame = CGRectMake(0, 0, width, 44);
    [navigationBtn setTitle:title forState:UIControlStateNormal];
    [navigationBtn setTitleColor:[self rightNavigationItemColor] forState:UIControlStateNormal];
    [navigationBtn setTitleColor:[self rightNavigationItemHightLightColor] forState:UIControlStateHighlighted];
    [navigationBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    navigationBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self addNavRightBtn:navigationBtn];
}

/**
 * 导航栏标题
 */
- (void)addNavTitleView:(UIView *)titleView {
    if (!titleView) {
        return;
    }
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;
}

- (CGFloat)selfNavigatorHeight {
    return IsiPad() ? 44 : 44;
}

- (CGFloat)selfStatusAndNavigatorHeight {
    return IsiOS7() ? 20.f + [self selfNavigatorHeight] : [self selfNavigatorHeight];//IOS7自定义navigator bar包含了状态栏20个px
}

- (UIColor *)navigationBarColor {
    return RGBCOLOR(53, 53, 53);
}

- (UIColor *)backgroundColor {
    return [UIColor whiteColor];
}

- (UIColor *)leftNavigationItemColor {
    return RGBCOLOR(53, 53, 53);
}

- (UIColor *)leftNavigationItemHightLightColor {
    return RGBACOLOR(53, 53, 53, 0.5);
}

- (UIFont *)leftNavigationItemFont {
    return [UIFont systemFontOfSize:17];
}

- (UIFont *)rightNavigationItemFont {
    return [UIFont systemFontOfSize:17];
}


#pragma mark ============== Other View =====================

- (HBEmptyView *)emptyView{
    if (!_emptyView) {
        _emptyView = [[HBEmptyView alloc] initWithFrame:[self getEmptyFrame]];
        [self.view addSubview:_emptyView];
        _emptyView.hidden = YES;
    }
    
    return _emptyView;
}

- (CGRect)getEmptyFrame{
    return self.view.bounds;
}

- (void)getEmptyView{
    
}

#pragma mark HBErrorViewDelegate
- (void)refreshBtnClicked{
    
}

- (BOOL)ensureShowOtherView{
    return NO;
}

/**
 * 显示正在加载页面
 */
- (void)showLoading:(BOOL)show {
    if (show) {
        if (!_indicator) {
            _indicator = [[HBProcessIndicator alloc] initWithFrame:self.view.bounds];
            [self.view addSubview:_indicator];
            
        }
        if ([self ensureShowOtherView]) {
            [self.view bringSubviewToFront:_indicator];
        }
        [_indicator showCustomIndicatorWithMessage:@"请骚候..."];
    } else {
        [_indicator endCustomIndicator];
    }
}

/**
 * 显示空页面
 */
- (void)showEmpty:(BOOL)show{
    if (show) {
        [self getEmptyView];
        
        if ([self ensureShowOtherView]) {
            [self.view bringSubviewToFront:_emptyView];
        }
        _emptyView.backgroundColor = [self backgroundColor];
        _emptyView.hidden = NO;
    } else {
        _emptyView.hidden = YES;
    }
}

/**
 * 显示加载失败页面
 */
- (void)showError:(BOOL)show{
    if (show) {
        if (!_errorView) {
            _errorView = [[HBErrorView alloc] initWithFrame:self.view.bounds];
            _errorView.delegate = self;
            [self.view addSubview:_errorView];
        }
        
        if ([self ensureShowOtherView]) {
            [self.view bringSubviewToFront:_errorView];
        }
        _errorView.backgroundColor = [self backgroundColor];
        [self.view bringSubviewToFront:_errorView];
        _errorView.hidden = NO;
    }
    else{
        _errorView.hidden = YES;
    }
}


#pragma mark - 弹出框
/*
 * by Soldier,2015.3.4
 */

//弹框时是否关闭交互
- (BOOL)userInteractionEnabledWhenShowIndicator {
    return NO;
}

//黑色提醒，渐显，自适应文本，支持多行，换行，\n 换行
- (void)showMsg:(NSString *)msg {
    if ([StringUtil isEmpty:msg]) {
        return;
    }
    SJTopTipView *tip = [[SJTopTipView alloc] initWithView:self.view msg:msg];
    [tip showMessage];
}

//黑色提醒（同上），延后
- (void)showMsgDelay:(NSString *)msg {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMsg:msg];
    });
}

//黑色提醒(同上)，windows层
- (void)showMsgOnWindows:(NSString *)msg {
    [SJTopTipView showMsgOnWindows:msg];
}

//黑色提醒(同上)，windows层，延后
- (void)showMsgOnWindowsDelay:(NSString *)msg {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SJTopTipView showMsgOnWindows:msg];
    });
}

//NavigationBar 下面红色提醒，从上往下
- (void)showHopTip:(NSString *)msg{
    if ([StringUtil isEmailLegal:msg]) {
        return;
    }
    SJTopTipView *tip = [[SJTopTipView alloc] initWithView:self.view msg:msg];
    [tip showTipMessage];
}

/*
 * 转圈，userInteractionEnabled = [self userInteractionEnabledWhenShowIndicator];
 */
- (void)showIndicator:(NSString *)msg {
    if (_loadMsgBox) {
        RELEASE_VIEW_SAFELY(_loadMsgBox);
    }
    _loadMsgBox = [[HBLoadMessageBox alloc] initWithLoadingText:msg andFinishText:nil];
    [self.view addSubview:_loadMsgBox];
    self.view.userInteractionEnabled = [self userInteractionEnabledWhenShowIndicator];
    [_loadMsgBox show];
}

/*
 * 转圈，userInteractionEnabled = YES;
 */
- (void)showIndicatorWithUserInteractionEnabled:(NSString *)msg {
    if (_loadMsgBox) {
        RELEASE_VIEW_SAFELY(_loadMsgBox);
    }
    _loadMsgBox = [[HBLoadMessageBox alloc] initWithLoadingText:msg andFinishText:nil];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:_loadMsgBox];
    [_loadMsgBox show];
}

/*
 * 关闭转圈
 */
- (void)endIndicator {
    if (_loadMsgBox) {
        [_loadMsgBox finish];
    }
    self.view.userInteractionEnabled = YES;
}

/*
 * diamiss关闭转圈
 */
- (void)endIndicatorDelay {
    if (_loadMsgBox) {
        [_loadMsgBox delayDissmis];
    }
    self.view.userInteractionEnabled = YES;
}

/*
 * endIndicatorDelay同名方法
 */
- (void)endProcessDelay {
    [self endIndicatorDelay];
}

/*
 * 关闭转圈，并显示ok Icon和msg
 */
- (void)endIndicatorWithIconAndMsg:(NSString *)msg {
    if (_loadMsgBox) {
        [_loadMsgBox finishWithMessage:msg];
    }
    self.view.userInteractionEnabled = YES;
}

/*
 * 关闭转圈，并显示msg
 */
- (void)endIndicator:(NSString *)msg {
    [self endIndicatorDelay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showMsg:msg];
    });
}

/*
 * 关闭转圈，并显示title，subTitle，不同字体
 */
- (void)endIndicator:(NSString *)title subTitle:(NSString *)subTitle {
    [self endIndicatorDelay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HBMessageBox *msgBox = [[HBMessageBox alloc] initWithTitle:title titleFont:[UIFont systemFontOfSize:ShowMessageBoxTitle] titleColor:[UIColor whiteColor] andMessageLabel:subTitle msgFont:[UIFont systemFontOfSize:ShowMessageBoxContent] msgColor:[UIColor whiteColor]];
        [self.view addSubview:msgBox];
        [msgBox show];
    });
    
    self.view.userInteractionEnabled = YES;
}
#pragma - mark


//声明空方法
- (void)showStatusBar:(id)show {
}

#pragma tabClickrefreshData 双击tab刷新方法

- (void)tabClickrefreshData {
}

//堆栈中前一个页面的名称
- (NSString *)preFileName{
    NSArray *array = self.navigationController.viewControllers;
    NSInteger count = array.count;
    if (count <= 1) {
        return nil;
    }
    
    UIViewController *vc = [array objectAtIndex:count - 2];
    if (!vc) {
        return nil;
    }
    const char *className  = class_getName(vc.class);
    NSString *resultName = [NSString stringWithCString:className encoding:NSUTF8StringEncoding];
    
    return resultName;
}

- (NSString *)selfFileName{
    const char *className = class_getName(self.class);
    NSString *resultName = [NSString stringWithCString:className encoding:NSUTF8StringEncoding];
    return resultName;
}

@end
