//
//  SJCollectionViewCell.h
//
//
//  Created by Soldier on 15-2-9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SJCollectionViewItem;

@interface SJCollectionViewCell : UICollectionViewCell{
    UIView *_bg;
    UIButton *_coverBtn;
    SJCollectionViewItem *_object;
}

- (id)object;

- (void)setObject:(id)object;

+ (CGFloat)collectionView:(UICollectionView *)collectionView rowHeightForObject:(id)object;

- (void)gridClick;

//设置点按效果的
- (void)setCoverBtnEnable;

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end
