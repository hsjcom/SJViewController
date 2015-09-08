//
//  SJCollectionViewDataSource.h
//  
//
//  Created by Soldier on 15-2-9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJCollectionViewLayout.h"

@class SJCollectionViewHeaderView;
@class SJCollectionViewFooterView;

@protocol SJCollectionViewDataSource <UICollectionViewDataSource>

- (id)collectionView:(UICollectionView *)collectionView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)collectionView:(UICollectionView *)collectionView cellClassForObject:(id)object;

- (NSIndexPath *)collectionView:(UICollectionView *)collectionView indexPathForObject:(id)object;

@end


@interface SJCollectionViewDataSource : NSObject<SJCollectionViewDataSource, UICollectionViewDelegateFlowLayout, SJCollectionViewLayoutDelegate>{
    NSMutableDictionary *_headerViews;
    NSMutableDictionary *_footerViews;
}

@property(nonatomic, strong) NSMutableArray *items;
@property(nonatomic, strong) NSMutableArray *mutiItems;


+ (SJCollectionViewDataSource *)dataSourceWithItems:(NSMutableArray *)items;

//用于多Section情况
+ (SJCollectionViewDataSource *)dataSourceWithMutiItems:(NSMutableArray *)items;


#pragma mark ------------header
//header头视图
- (SJCollectionViewHeaderView *)headerView;

//section对应的header头视图
- (SJCollectionViewHeaderView *)headerViewForSection:(NSUInteger)section;

//header头视图
- (SJCollectionViewHeaderView *)constructHeaderView:(UICollectionView *)collectionView;

//section对应的header头视图
- (SJCollectionViewHeaderView *)constructHeaderViewForSection:(NSUInteger)section
                                                      andView:(UICollectionView *)collectionView;

/**
 * header头的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForHeaderInSection:(NSInteger)section;

- (Class)headerClassForSection:(NSUInteger)section collectionView:(UICollectionView *)collectionView ;

#pragma mark ------------header
//footer视图
- (SJCollectionViewFooterView *)footerView;

//section对应的footer视图
- (SJCollectionViewFooterView *)footerViewForSection:(NSUInteger)section;

//footer视图
- (SJCollectionViewFooterView *)constructFooterView:(UICollectionView *)collectionView;

//section对应的footer视图
- (SJCollectionViewFooterView *)constructFooterViewForSection:(NSUInteger)section
                                                      andView:(UICollectionView *)collectionView;


/**
 * footer的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForFooterInSection:(NSInteger)section;


@end
