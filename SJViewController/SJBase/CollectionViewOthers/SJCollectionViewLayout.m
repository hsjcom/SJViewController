//
//  SJCollectionViewLayout.m
//  SJCollectionViewLayout
//
//  Created by Kevin Lundberg on 6/14/14.
//  Copyright (c) 2014 Kevin Lundberg. All rights reserved.
//

#import "SJCollectionViewLayout.h"

@interface SJCollectionViewLayout ()

@property (nonatomic, weak) id <SJCollectionViewLayoutDelegate> aDelegate;  //自动设置的代理
@property (nonatomic, strong) NSMutableArray *columnHeights;//元素为数组，每一个数组存的元素为该section的各列高
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;//二元数组 section item
@property (nonatomic, strong) NSMutableArray *allItemAttributes;//所有的元素
@property (nonatomic, strong) NSMutableArray *headerAttributes;//各seciton的header
@property (nonatomic, strong) NSMutableArray *footerAttrubites;//各seciton的footer

@end




@implementation SJCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    _numberOfItemsPerLines = [NSMutableArray arrayWithObject:@1];
    _sectionInsets = [NSMutableArray arrayWithObject:NSStringFromUIEdgeInsets(UIEdgeInsetsZero)];
    _XSpacings = [NSMutableArray arrayWithObject:@0.f];
    _YSpacings = [NSMutableArray arrayWithObject:@0.f];
}

#pragma mark - rewrite method

//重载方法
- (void)prepareLayout
{
    //初始化
    [super prepareLayout];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0)
    {
        return;
    }
    
    self.aDelegate = (id <SJCollectionViewLayoutDelegate> )self.collectionView.dataSource;
    
    [self.columnHeights removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    [self.allItemAttributes removeAllObjects];
    [self.headerAttributes removeAllObjects];
    [self.footerAttrubites removeAllObjects];
    
    // Create attributes
    
    UICollectionViewLayoutAttributes *attributes;
    NSUInteger idx = 0;

    //初始化height数据
    for(NSInteger i = 0; i < numberOfSections; i++){
        NSMutableArray *columHeightsOfSection = [NSMutableArray array];
        NSInteger columnNum = [self numberOfItemsPerLine:i];
        for(NSInteger j = 0; j < columnNum; j++){
            [columHeightsOfSection addObject:@(0)];
        }
        [self.columnHeights addObject:columHeightsOfSection];
    }
    
    for (NSInteger section = 0; section < numberOfSections; ++section)
    {
        CGFloat topForColumn = 0.f;
        CGFloat topOfSection = [self topOfSection:section];
        UIEdgeInsets sectionInset = [self sectionInset:section];
        
        /*
         * 1. Section header
         */
        CGFloat headerHeight;
        if ([self.aDelegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)])
        {
            headerHeight = [self.aDelegate collectionView:self.collectionView layout:self heightForHeaderInSection:section];
        }
        else
        {
            headerHeight = 0.f;
        }
        
        if (headerHeight > 0)
        {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:SJCollectionViewHeader withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            attributes.frame = CGRectMake(0, topOfSection, self.collectionView.frame.size.width, headerHeight);
            [self.headerAttributes addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            
            topForColumn += CGRectGetHeight(attributes.frame);
        }
        
        topForColumn += sectionInset.top;
        
        NSMutableArray *tmpHeights = [self columnHeights:section];
        for (idx = 0; idx < tmpHeights.count; idx++)
        {
            tmpHeights[idx] = @(topForColumn);
        }
        
        /*
         * 2. Section items
         */
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        
        // Item will be put into shortest column.
        for (idx = 0; idx < itemCount; idx++)
        {
            //size
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            CGFloat itemWidth = [self itemWidth:section];
            CGFloat itemHeight = [self.aDelegate collectionView:self.collectionView
                                                         layout:self
                                               heightForSection:section
                                                   forItemIndex:idx];
            
            
            //origin
            NSUInteger columnIndex = [self shortestColumnIndex:section];
            CGFloat xPadding = [self XSpacing:section];
            CGFloat yPadding = [self YSpacing:section];
            CGFloat xOffset = sectionInset.left + (itemWidth + xPadding) * columnIndex;
            CGFloat columBottom = [self columnHeight:section andIndex:columnIndex];
            CGFloat yOffset = columBottom + topOfSection;
            
            //frame
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
            [itemAttributes addObject:attributes];
            
            //manage data
            [self.allItemAttributes addObject:attributes];
            
            NSNumber *theColumnHeight = @(columBottom + itemHeight + yPadding);
            (self.columnHeights[section])[columnIndex] = theColumnHeight;
        }
        
        [self.sectionItemAttributes addObject:itemAttributes];
        
        /*
         * Section footer
         */
        CGFloat footerHeight;
        topForColumn = sectionInset.bottom + [self longestColumnHeightSection:section];
        
        if ([self.aDelegate respondsToSelector:@selector(collectionView:layout:heightForFooterInSection:)])
        {
            footerHeight = [self.aDelegate collectionView:self.collectionView layout:self heightForFooterInSection:section];
        }
        else
        {
            footerHeight = 0.f;
        }
        
        if (footerHeight > 0)
        {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:SJCollectionViewFooter withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            CGFloat top = topForColumn + topOfSection;
            attributes.frame = CGRectMake(0, top, self.collectionView.frame.size.width, footerHeight);
            
            [self.footerAttrubites addObject:attributes];
            [self.allItemAttributes addObject:attributes];
            
            topForColumn += footerHeight;
        }
        
        //save data
        for (idx = 0; idx < tmpHeights.count; idx++)
        {
            tmpHeights[idx] = @(topForColumn);
        }
    }
    
}

//重载方法
//返回collectionView的内容的尺寸
- (CGSize)collectionViewContentSize
{
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    if (numberOfSections == 0)
    {
        return CGSizeZero;
    }
    
    CGSize contentSize = self.collectionView.bounds.size;
    CGFloat totalHeight = 0.f;
    
    for(NSUInteger section = 0; section < self.columnHeights.count; section++){
        totalHeight += [self columnHeight:section andIndex:0];
    }
    contentSize.height = totalHeight;
    
    return contentSize;
}

//重载方法
//返回对应于indexPath的位置的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    if (path.section >= [self.sectionItemAttributes count])
    {
        return nil;
    }
    if (path.item >= [self.sectionItemAttributes[path.section] count])
    {
        return nil;
    }
    
    return (self.sectionItemAttributes[path.section])[path.item];
}

//重载方法
//返回对应于indexPath的位置的追加视图的布局属性，如果没有追加视图可不重载
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attribute = nil;
    if ([kind isEqualToString:SJCollectionViewHeader])
    {
        NSUInteger index = indexPath.section;
        attribute = [self.headerAttributes objectAtIndex:index];
    } else if ([kind isEqualToString:SJCollectionViewFooter])
    {
        NSUInteger index = indexPath.section;
        attribute = [self.footerAttrubites objectAtIndex:index];
    }
    return attribute;
}

//重载方法
//返回rect中的所有的元素的布局属性
//返回的是包含UICollectionViewLayoutAttributes的NSArray
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visibleAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.allItemAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [visibleAttributes addObject:attributes];
        }
    }
    
    return visibleAttributes;
}


//重载方法
//当边界发生改变时，是否应该刷新布局。如果YES则在边界变化（一般是scroll到其他地方）时，将重新计算需要的布局信息。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds) ||
        CGRectGetHeight(newBounds) != CGRectGetHeight(oldBounds))
    {
        return YES;
    }
    return NO;
}


#pragma mark - Private Methods
/**
 *  Find the shortest column.
 *
 *  @return index for the shortest column
 */
- (NSUInteger)shortestColumnIndex:(NSUInteger)section
{
    __block NSUInteger index = 0;
    __block CGFloat resultHeight = MAXFLOAT;
    
    if (self.columnHeights.count > section) {
        NSArray *heights = self.columnHeights[section];
        [heights enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            CGFloat theHeight = [obj floatValue];
            if (theHeight < resultHeight) {
                resultHeight = theHeight;
                index = idx;
            }
        }];
    }
    
    return index;
}

- (CGFloat)longestColumnHeightSection:(NSUInteger)section{
    if (self.columnHeights.count <= section) {
        return 0.f;
    }
    
    CGFloat resultHeight = 0.f;
    NSArray *columsInSection = self.columnHeights[section];
    for(NSUInteger j = 0; j < columsInSection.count; j++){
        NSNumber *columHeight = columsInSection[j];
        CGFloat theHeight = [columHeight floatValue];
        if (theHeight > resultHeight) {
            resultHeight = theHeight;
        }
    }
    
    return resultHeight;
}


- (CGFloat)itemWidth:(NSUInteger)section{
    if (self.numberOfItemsPerLines.count <= section ||
        self.XSpacings.count <= section) {
        return 0.f;
    }
    
    //width
    UIEdgeInsets sectionInset = [self sectionInset:section];
    CGFloat width = self.collectionView.width - sectionInset.left - sectionInset.right;
    
    //columCount
    NSUInteger columnCount = [self numberOfItemsPerLine:section];
    if (0 == columnCount) {
        return 0;
    }
    
    //spacing
    CGFloat spacing = [self XSpacing:section];
    CGFloat itemWidth = floorf((width - (columnCount - 1) * spacing) / columnCount);
    return itemWidth;
}

//指定的section的顶部位置
- (CGFloat)topOfSection:(NSUInteger)section{
    if (_columnHeights.count <= section) {
        return 0.f;
    }

    CGFloat top = 0.f;
    for(NSUInteger i = 0; i < section; i++){
        top += [self columnHeight:i andIndex:0];
    }
    return top;
}

#pragma mark - Public Accessors
- (void)setNumberOfItemsPerLines:(NSMutableArray *)numberOfItemsPerLines
{
    if (_numberOfItemsPerLines != numberOfItemsPerLines) {
        _numberOfItemsPerLines = numberOfItemsPerLines;
        
        [self invalidateLayout];
    }
}

- (NSUInteger)numberOfItemsPerLine:(NSUInteger)section{
    if (_numberOfItemsPerLines.count <= section) {
        return 0;
    }
    
    NSNumber *num = _numberOfItemsPerLines[section];
    return num.integerValue;
}

- (void)setXSpacings:(NSMutableArray *)interitemSpacings {
    if (_XSpacings != interitemSpacings) {
        _XSpacings = interitemSpacings;
        
        [self invalidateLayout];
    }
}

- (CGFloat)XSpacing:(NSUInteger)section{
    if (_XSpacings.count <= section) {
        return 0.f;
    }
    
    NSNumber *num = _XSpacings[section];
    return num.floatValue;
}

- (void)setYSpacings:(NSMutableArray *)lineSpacings
{
    if (_YSpacings != lineSpacings) {
        _YSpacings = lineSpacings;
        
        [self invalidateLayout];
    }
}

- (CGFloat)YSpacing:(NSUInteger)section{
    if (_YSpacings.count <= section) {
        return 0.f;
    }
    
    NSNumber *num = _YSpacings[section];
    return num.floatValue;
}

- (void)setSectionInsets:(NSMutableArray *)sectionInsets
{
    if (_sectionInsets != sectionInsets)
    {
        _sectionInsets = sectionInsets;
        [self invalidateLayout];
    }
}

- (UIEdgeInsets)sectionInset:(NSUInteger)section{
    if (self.sectionInsets.count <= section) {
        return UIEdgeInsetsZero;
    }
    
    NSString *insetString = self.sectionInsets[section];
    UIEdgeInsets sectionInset = UIEdgeInsetsFromString(insetString);
    return sectionInset;
}

- (NSMutableArray *)columnHeights
{
    if (!_columnHeights)
    {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

- (NSMutableArray *)columnHeights:(NSUInteger)section{
    if (_columnHeights.count <= section) {
        return nil;
    }
    
    return _columnHeights[section];
}

- (CGFloat)columnHeight:(NSUInteger)section andIndex:(NSUInteger)index{
    if (_columnHeights.count <= section) {
        return 0.f;
    }
    
    if ([_columnHeights[section] count] <= index) {
        return 0.f;
    }
    
    NSNumber *num = (_columnHeights[section])[index];
    return num.floatValue;
}

- (NSMutableArray *)allItemAttributes
{
    if (!_allItemAttributes)
    {
        _allItemAttributes = [NSMutableArray array];
    }
    return _allItemAttributes;
}

- (NSMutableArray *)sectionItemAttributes
{
    if (!_sectionItemAttributes)
    {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}



@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
