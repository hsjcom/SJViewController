//
//  SJWebViewController.m
//
//
//  Created by Soldier on 15-2-5.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJWebViewController.h"
#import "DeviceInfo.h"

@implementation SJWebViewController

- (void)dealloc {
    RELEASE_VIEW_SAFELY(_progressView);
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [_webView setDelegate:nil];
}

- (id)initWithQuery:(NSDictionary *)query {
    self = [super initWithQuery:query];
    if (self) {
        _showNavRefreshBtn = YES;
        self.reqUrl = [self.query objectForKey:WEB_URL_KEY];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self constructWebView];
    [self constructProgress];
    [self constructBackView];
    
    if (![NSString isEmpty:self.reqUrl]) {
        [self openRequest:self.reqUrl];
    } else {
        NSLog(@"_loadingURL = nill~~~");
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    // If the browser launched the media player, it steals the key window and never gives it
    // back, so this is a way to try and fix that
    [self.view.window makeKeyWindow];
    [super viewWillDisappear:animated];
    
    [_backBtnClose removeFromSuperview];
    [_webBackBtn removeFromSuperview];
}

- (void)constructBackView{
    _webBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _webBackBtn.frame = CGRectMake(0, 20, 70, 44);
    _webBackBtn.backgroundColor = [UIColor clearColor];
    [_webBackBtn addTarget:self
                    action:@selector(backView)
          forControlEvents:UIControlEventTouchUpInside];
    
    _backBtnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtnClose.frame = CGRectMake(IsiPhone6AndAbove() ? _webBackBtn.right - 15: _webBackBtn.right - 25, 20, 60, 44);
    _backBtnClose.backgroundColor = [UIColor clearColor];
    [_backBtnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [_backBtnClose setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    _backBtnClose.titleLabel.font = [UIFont systemFontOfSize:17];
    [_backBtnClose setTitleColor:COLOR_TEXT_2 forState:UIControlStateNormal];
    [_backBtnClose setTitleColor:COLOR_TEXT_2 forState:UIControlStateHighlighted];
    [_backBtnClose addTarget:self
                      action:@selector(backViewClose)
            forControlEvents:UIControlEventTouchUpInside];
    [_backBtnClose setHidden:YES];
    
    [self.navigationController.view addSubview:_backBtnClose];
    
    [self.navigationController.view addSubview:_webBackBtn];
}

- (void)showNavRefresh {
    if (!_showNavRefreshBtn) {
        return;
    }
    if (!_navRefreshBtn) {
        _navRefreshBtn = [ViewConstructUtil constructButton:[self rightBtnFrame] nlBgImg:[UIImage imageNamed:@"refreshBtn.png"] hlBgImg:[UIImage imageNamed:@"refreshBtn_hl.png"] slBgImg:[UIImage imageNamed:@"refreshBtn_hl.png"] target:self action:@selector(refreshAction)];
    }
    [self addNavRightBtn:_navRefreshBtn];
}

- (void)refreshAction {
    if (![NSString isEmpty:self.reqUrl]) {
        [self openRequest:self.reqUrl];
    }else{
        NSLog(@"_loadingURL = nill~~~");
    }
}

- (void)constructWebView {
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor clearColor];
    
    _webView.scalesPageToFit = YES;
    if (self.query && [self.query objectForKey:@"ScalesPageToFit"]) {
        _webView.scalesPageToFit = NO;
    }
    [self.view addSubview:_webView];
}

//进度条
- (void)constructProgress{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _progressView.progressBarView.backgroundColor = [UIColor redColor];
    [self.navigationController.navigationBar addSubview:_progressView];
    _progressView.progress = 0;
}

- (void)openRequest:(NSString *)_url {
    _request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];

    [self addCommonHeadInfo];
    
    [_webView loadRequest:_request];
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    [_progressView setProgress:progress animated:YES];
}

- (void)backViewClose{
    [super backView];
}

- (void)backView {
    if([_webView canGoBack]){
        [_webView goBack];
        
        [_backBtnClose setHidden:NO];
        
        return;
    }
    [super backView];
}

- (BOOL)isWebURL:(NSURL*)URL {
    return [URL.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"ftp"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"ftps"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"data"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"file"] == NSOrderedSame;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;{
    //  判断是否 属于 app 间跳转  非纯 http 跳转
    if ([[UIApplication sharedApplication] canOpenURL:request.URL] && ![self isWebURL:request.URL]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showNavRefresh) userInfo:nil repeats:NO];
    
    //获取html标题
    if ([StringUtil isEmpty:self.title] || [self.title isEqualToString:@"详情"]) {
        NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if ([StringUtil isEmpty:title]) {
            title = @"详情";
        }
        self.title = [StringUtil subString:title length:13 trail:YES];
    }
    
    _webView.dataDetectorTypes = UIDataDetectorTypeNone;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"web view didFailLoadWithError=:%@ ",error);
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showNavRefresh) userInfo:nil repeats:NO];
}

/**
 * 添加 公共头信息
 */
- (void)addCommonHeadInfo{
//    [request setValue:@"" forHTTPHeaderField:@"LA" ];
}


@end
