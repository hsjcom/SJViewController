//
//  SJModelViewController.h
//  SoldierViewController
//
//  Created by Soldier on 15-2-2.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJViewController.h"

typedef NS_ENUM(NSInteger, PullLoadType) {
    PullDefault = 0,
    PullDownRefresh = 1,
    PullUpLoadMore  = 2,
};

@interface SJModelViewController : SJViewController<UIAlertViewDelegate>{
    SJHTTPRequest *_req;
}

@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, assign) BOOL isFirstAppear;

@property(nonatomic, assign) BOOL isLoading;

/**
 *  是否立即显示加载中
 */
@property(nonatomic, assign) BOOL isShowLoadingPromptly;


/**
 *  是否正在上拉刷新
 */
@property(nonatomic, assign) BOOL isPullingUp;

- (NSString *)requestUrl;

- (NSUInteger)cacheTime;

- (void)createModel;

- (void)didFinishLoad:(SJHTTPRequest *)request;

- (void)didFailLoadWithError:(SJHTTPRequest *)request;

- (void)modelDidFinishLoad:(SJHTTPRequest *)request;

- (void)modeldidFailLoadWithError:(SJHTTPRequest *)request;

- (void)modelDidStartLoad;

- (void)onDataUpdated;

- (void)onLoadFailed;



@end
