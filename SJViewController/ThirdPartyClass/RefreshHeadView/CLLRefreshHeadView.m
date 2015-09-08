//
//  CLLRefreshHeadView.m
//  RefreshLoadView
//
//  Created by chuliangliang on 14-6-12.
//  Copyright (c) 2014年 aikaola. All rights reserved.
//

#import "CLLRefreshHeadView.h"

@implementation CLLRefreshHeadView

//刷新操作提示
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width * 0.5 - 200 * 0.5, self.height - 20, 200, 14)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = [UIFont systemFontOfSize:10.f];
        _statusLabel.textColor = COLOR_TEXT_2;
    }
    return _statusLabel;
}

//时间
//- (UILabel *)timeLabel {
//    if (!_timeLabel) {
//        CGRect timeLabelFrame = self.statusLabel.frame;
//        timeLabelFrame.origin.y += CGRectGetHeight(timeLabelFrame) + 6;
//        _timeLabel = [[UILabel alloc] initWithFrame:timeLabelFrame];
//        _timeLabel.backgroundColor = [UIColor clearColor];
//        _timeLabel.font = [UIFont systemFontOfSize:11.f];
//        _timeLabel.textColor = [UIColor colorWithWhite:0.659 alpha:1.000];
//    }
//    return _timeLabel;
//}

//刷新圆圈
- (RefreshAnimationView *)circleView {
    if (!_circleView) {
        _circleView = [[RefreshAnimationView alloc] initWithFrame:CGRectMake(self.width * 0.5 - 36 * 0.5, 5, 36, 36)];
    }
    return _circleView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.statusLabel];
//        [self addSubview:self.timeLabel];
        [self addSubview:self.circleView];
    }
    return self;
}

@end
