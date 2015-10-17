//
//  SJWebViewController.h
//
//
//  Created by Soldier on 15-2-5.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJModelViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface SJWebViewController : SJModelViewController<UIWebViewDelegate, UIActionSheetDelegate,NJKWebViewProgressDelegate>{
    
    UIButton *_webBackBtn;
    UIButton *_backBtnClose;
    
    NSMutableURLRequest *_request;
    
    NJKWebViewProgress *_progressProxy;
    NJKWebViewProgressView *_progressView;
    
    UIButton *_navRefreshBtn;
    BOOL _showNavRefreshBtn;
    
    NSString *_contentType;
}

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSString *reqUrl;

- (void)openRequest:(NSString *)_url;

@end
