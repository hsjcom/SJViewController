//
//  CLLRefreshFooterView.m
//  RefreshLoadView
//
//  Created by chuliangliang on 14-12-26.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "CLLRefreshFooterView.h"

@implementation CLLRefreshFooterView

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(135,(self.bounds.size.height - 14) * 0.5, 160, 14)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:15.f];
        _statusLabel.textColor = RGBCOLOR(128, 127, 127);
    }
    return _statusLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(110,(self.bounds.size.height - 20) * 0.5,20,20);
        _indicatorView.hidesWhenStopped = YES;
    }
    return _indicatorView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.indicatorView];
        [self addSubview:self.statusLabel];
    }
    return self;
}

- (void)resetView {
    if (self.indicatorView.isAnimating) {
        [self.statusLabel sizeToFit];
        CGRect tmpFrame = _indicatorView.frame;
        tmpFrame.origin.x = (self.bounds.size.width - tmpFrame.size.width - _statusLabel.frame.size.width - 5) * 0.5;
        tmpFrame.origin.y = (self.bounds.size.height - tmpFrame.size.height) * 0.5;
        self.indicatorView.frame = tmpFrame;
        
        tmpFrame.origin.x = _indicatorView.frame.origin.x + _indicatorView.frame.size.width + 5;
        tmpFrame.origin.y = (self.bounds.size.height - _statusLabel.frame.size.height) * 0.5;
        tmpFrame.size = _statusLabel.frame.size;
        self.statusLabel.frame = tmpFrame;
    }else {
        [self.statusLabel sizeToFit];
        CGRect tmpFrame = self.statusLabel.frame;
        tmpFrame.origin.x = (self.bounds.size.width - tmpFrame.size.width ) * 0.5;
        tmpFrame.origin.y = (self.bounds.size.height - tmpFrame.size.height) * 0.5;
        self.statusLabel.frame = tmpFrame;
    }
}

@end
