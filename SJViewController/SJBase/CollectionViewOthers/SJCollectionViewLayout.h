//
//  SJCollectionViewLayout.h
//  SJCollectionViewLayout
//
//  Created by Kevin Lundberg on 6/14/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

static NSString *const SJCollectionViewHeader = @"SJCollectionViewHeader";
static NSString *const SJCollectionViewFooter = @"SJCollectionViewFooter";


@protocol SJCollectionViewLayoutDelegate <NSObject>

@required
/**
 * 获得指定的元素的高度
 *  @param  collectionView
 *
 *  @param  collectionViewLayout
 *
 *  @param  indexPath
 *  指定的元素
 *
 *  @return
 *  指定的元素的高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
         heightForSection:(NSInteger )section
             forItemIndex:(NSUInteger)index;

@optional
/**
 *  获得指定节块的头视图高度
 *  @param collectionView
 *
 *  @param collectionViewLayout
 *
 *  @param section
 *  指定节块
 *
 *  @return
 *  指定节块的头视图高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForHeaderInSection:(NSInteger)section;

/**
 *  获得指定节块的底视图高度
 *  @param collectionView
 *
 *  @param collectionViewLayout
 *
 *  @param section
 *  指定节块
 *
 *  @return
 *  指定节块的底视图高度
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForFooterInSection:(NSInteger)section;

@end



/**
 A layout that positions and sizes cells based on the numberOfItemsPerLine properties.
 */
@interface SJCollectionViewLayout : UICollectionViewLayout
/**
 How many items the layout should place on a single line.
 Defaults to 1.
 */
@property (nonatomic, strong) NSMutableArray *numberOfItemsPerLines;

/**
 How much space the layout should place between items on the same line.
 Defaults to 10.
 */
@property (nonatomic, strong) NSMutableArray *XSpacings;

/**
 How much space the layout should place between lines.
 Defaults to 10.
 */
@property (nonatomic, strong) NSMutableArray *YSpacings;

/**
 If specified, each section will have a border around it defined by these insets.
 Defaults to UIEdgeInsetsZero.
 */
@property (nonatomic, strong) NSMutableArray *sectionInsets;

@end


