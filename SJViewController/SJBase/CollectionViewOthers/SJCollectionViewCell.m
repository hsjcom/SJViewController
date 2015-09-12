//
//  SJCollectionViewCell.m
//
//
//  Created by Soldier on 15-2-9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJCollectionViewCell.h"
#import "SJCollectionViewItem.h"

@implementation SJCollectionViewCell

- (void)dealloc {
    [self setObject:nil];
}

+ (CGFloat)collectionView:(UICollectionView *)collectionView rowHeightForObject:(id)object {
    return 88;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _bg = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_bg];
    }
    return self;
}

- (id)object {
    return _object;
}

- (void)prepareForReuse {
    self.object = nil;
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    if (object != _object) {
        _object = object;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

- (void)gridClick{
    SJCollectionViewItem *item = (SJCollectionViewItem *)self.object;
    if (item.delegate && [item.delegate respondsToSelector:item.selector]){
        SafePerformSelector([item.delegate performSelector:item.selector withObject:item]);
    }
}

//设置点按效果的
- (void)setCoverBtnEnable{
    if (!_coverBtn) {
        _coverBtn = [ViewConstructUtil constructButton:self.bounds
                                                target:self
                                                action:@selector(gridClick)];
                     
        [self addSubview:_coverBtn];
    }
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [_coverBtn removeTarget:self action:@selector(gridClick) forControlEvents:controlEvents];
    [_coverBtn addTarget:target action:action forControlEvents:controlEvents];
}


@end
