//
//  SJModelViewController.m
//  SoldierViewController
//
//  Created by Soldier on 15-2-2.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJModelViewController.h"

@implementation SJModelViewController

- (void)dealloc {
    [_req clearDelegatesAndCancel];
    _req = nil;
    self.items = nil;
}

- (NSString *)requestUrl{
    return nil;
}

- (NSUInteger)cacheTime{
    return 0;
}

- (void)createModel{
    if (![StringUtil isEmpty:[self requestUrl]]) {
        [_req clearDelegatesAndCancel];
        _req = [[SJHTTPRequest alloc] initWithURL:[self requestUrl] andDelegate:self];
        [_req setCacheTime:[self cacheTime]];
        [_req addSelectFinish:@selector(didFinishLoad:) andDidFailSelector:@selector(didFailLoadWithError:)];
        [_req sendRequest];
    }
    
    [self modelDidStartLoad];
}

- (void)didFinishLoad:(SJHTTPRequest *)request {
    [self modelDidFinishLoad:request];
    [self onDataUpdated];
}

- (void)didFailLoadWithError:(SJHTTPRequest *)request {
    [self modeldidFailLoadWithError:request];
    [self onLoadFailed];
}

- (void)modelDidFinishLoad:(SJHTTPRequest *)request {
    
}

- (void)modeldidFailLoadWithError:(SJHTTPRequest *)request {
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.isFirstAppear = YES;
    
    self.isLoading = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isFirstAppear = NO;
}

- (void)onLoadFailed {
    [self showLoading:NO];
    [self showError:YES];
    
    self.isLoading = NO;
}

- (void)onDataUpdated {
    [self showLoading:NO];
    [self showError:NO];
    
    self.isLoading = NO;
}

- (void)modelDidStartLoad {
    
    //如果立即显示而且不是在下拉刷新
    if (self.isShowLoadingPromptly && !self.isPullingUp) {
        [self showLoading:YES];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //如果现在加载中而且不是在下拉刷新
            if (self.isLoading && !self.isPullingUp) {
                [self showLoading:YES];
            }
        });
    }
    [self showError:NO];
    self.isLoading = YES;
}

@end
