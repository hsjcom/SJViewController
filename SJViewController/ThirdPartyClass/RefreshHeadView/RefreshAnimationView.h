//
//  RefreshAnimationView.h
//  
//
//  Created by Soldier on 15-2-6.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshAnimationView : UIView {
    UIImageView *_refreshViewBg;
    UIImageView *_refreshLoadingView;
}

@property(nonatomic, assign) float progress;

- (void)pullingAnimation:(float)progress;

- (void)startLoadingAnimation;

- (void)stopLoadingAnimation;

@end
