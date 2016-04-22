//
//  FDSlideBar.m
//  FDSlideBarDemo
//
//  Created by fergusding on 15/6/4.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDSlideBar.h"
#import "FDSlideBarItem.h"

#define DEVICE_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define DEFAULT_SLIDER_COLOR [UIColor orangeColor]
#define SLIDER_VIEW_HEIGHT 2

@interface FDSlideBar () <FDSlideBarItemDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UIView *sliderView;

@property (strong, nonatomic) FDSlideBarItem *selectedItem;
@property (strong, nonatomic) FDSlideBarItemSelectedCallback callback;

@property (nonatomic, weak) UIImageView *leftImgV;
@property (nonatomic, weak) UIImageView *rightImgV;

@end

@implementation FDSlideBar

#pragma mark - Lifecircle

- (instancetype)init {
    CGRect frame = CGRectMake(0, 20, DEVICE_WIDTH, 46);
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _items = [NSMutableArray array];
        UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        lineImageView.backgroundColor = COLOR_TEXT_2;
        [self addSubview:lineImageView];
        [self initScrollView];
        [self initLeftRightView];
        [self initSliderView];
    }
    return self;
}

#pragma - mark Custom Accessors

- (void)setItemsTitle:(NSArray *)itemsTitle {
    _itemsTitle = itemsTitle;
    [self setupItems];
}

- (void)setItemColor:(UIColor *)itemColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemTitleColor:itemColor];
    }
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    for (FDSlideBarItem *item in _items) {
        [item setItemSelectedTitleColor:itemSelectedColor];
    }
}

- (void)setSliderColor:(UIColor *)sliderColor {
    _sliderColor = sliderColor;
    self.sliderView.backgroundColor = _sliderColor;
}

- (void)setSelectedItem:(FDSlideBarItem *)selectedItem {
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
}


#pragma - mark Private

- (void)initLeftRightView{
    UIImageView *leftImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, self.height)];
    leftImgV.image = [[UIImage imageNamed:@"find_slider_left_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self addSubview:leftImgV];
    self.leftImgV = leftImgV;
    
    UIImageView *rightImgV = [[UIImageView alloc]initWithFrame:CGRectMake(self.width - 30, 0, 30, self.height)];
    rightImgV.image = [[UIImage imageNamed:@"find_slider_right_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self addSubview:rightImgV];
    self.rightImgV = rightImgV;
}

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.scrollsToTop = NO;
    _scrollView.bounces = YES;
    [self addSubview:_scrollView];
}

- (void)initSliderView {
    _sliderView = [[UIView alloc] init];
    _sliderColor = DEFAULT_SLIDER_COLOR;
    _sliderView.backgroundColor = _sliderColor;
    [_scrollView addSubview:_sliderView];
}

/**
 * by Soldier
 * 是否平分tab
 */
- (BOOL)isAverage {
    float itemW = 0;
    for (NSString *title in _itemsTitle) {
        itemW += [FDSlideBarItem widthForTitle:title];
    }
    if (_itemsTitle.count > 1 && itemW < _scrollView.width) {
        return YES;
    }
    return NO;
}

- (void)setupItems {
    [_items removeAllObjects];
    
    BOOL isAve = [self isAverage];
    
    for (UIView *itemView in _scrollView.subviews) {
        if ([itemView isKindOfClass:[FDSlideBarItem class]]) {
            FDSlideBarItem *slideBarItem = (FDSlideBarItem *)itemView;
            slideBarItem.delegate = nil;
            [slideBarItem removeFromSuperview];
        }
    }
    CGFloat itemX = 0;
    for (NSString *title in _itemsTitle) {
        FDSlideBarItem *item = [[FDSlideBarItem alloc] init];
        item.delegate = self;
        
        // Init the current item's frame
        
        /**
         * by Soldier
         */
        CGFloat itemW  = _scrollView.width * 0.5;
        if (isAve) {
            itemW = _scrollView.width / _itemsTitle.count;
        } else {
            itemW = [FDSlideBarItem widthForTitle:title];
        }
        
        item.frame = CGRectMake(itemX, 0, itemW, CGRectGetHeight(_scrollView.frame));
        [item setItemTitle:title];
        [_items addObject:item];
        
        [_scrollView addSubview:item];
        
        // Caculate the origin.x of the next item
        itemX = CGRectGetMaxX(item.frame);
    }
    
    // Cculate the scrollView 's contentSize by all the items
    _scrollView.contentSize = CGSizeMake(itemX, CGRectGetHeight(_scrollView.frame));
    
    // Set the default selected item, the first item
    FDSlideBarItem *firstItem = [self.items firstObject];
    firstItem.selected = YES;
    _selectedItem = firstItem;
    self.leftImgV.hidden = YES;
    // Set the frame of sliderView by the selected item
//    _sliderView.frame = CGRectMake(0, self.frame.size.height - SLIDER_VIEW_HEIGHT, firstItem.frame.size.width, SLIDER_VIEW_HEIGHT);
    _sliderView.frame = CGRectMake(0, self.frame.size.height - SLIDER_VIEW_HEIGHT, 30, SLIDER_VIEW_HEIGHT);
    _sliderView.centerX = firstItem.centerX;
}

- (void)scrollToVisibleItem:(FDSlideBarItem *)item {
    NSInteger selectedItemIndex = [self.items indexOfObject:_selectedItem];
    NSInteger visibleItemIndex = [self.items indexOfObject:item];
    
    // If the selected item is same to the item to be visible, nothing to do
    if (selectedItemIndex == visibleItemIndex ) {
        return;
    }
    
    //中间位置的差值
    CGFloat offsetx = item.center.x - self.scrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.scrollView.contentSize.width - self.scrollView.frame.size.width;

    
    //中间位置的差值小于0说明这item的中点小于中心点，如果大于测移动相应的距离item居中，但是不超过最大的offsetMax
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    
    if (self.scrollView.contentSize.width > UI_SCREEN_WIDTH) {
        [_scrollView setContentOffset:CGPointMake(offsetx, self.scrollView.contentOffset.y) animated:YES];
    }
    
    
//    CGPoint offset = _scrollView.contentOffset;
    
    // If the item to be visible is in the screen, nothing to do
//    if (CGRectGetMinX(item.frame) > offset.x && CGRectGetMaxX(item.frame) < (offset.x + CGRectGetWidth(_scrollView.frame))) {
//        return;
//    }
    
//    // Update the scrollView's contentOffset according to different situation
//    if (selectedItemIndex < visibleItemIndex) {
//        // The item to be visible is on the right of the selected item and the selected item is out of screeen by the left, also the opposite case, set the offset respectively
//        if (CGRectGetMaxX(_selectedItem.frame) < offset.x) {
//            offset.x = CGRectGetMinX(item.frame);
//        } else {
//            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
//        }
//    } else {
//        // The item to be visible is on the left of the selected item and the selected item is out of screeen by the right, also the opposite case, set the offset respectively
//        if (CGRectGetMinX(_selectedItem.frame) > (offset.x + CGRectGetWidth(_scrollView.frame))) {
//            offset.x = CGRectGetMaxX(item.frame) - CGRectGetWidth(_scrollView.frame);
//        } else {
//            offset.x = CGRectGetMinX(item.frame);
//        }
//    }
//    _scrollView.contentOffset = offset;
}

- (void)addAnimationWithSelectedItem:(FDSlideBarItem *)item {
    // Caculate the distance of translation
    CGFloat dx = CGRectGetMidX(item.frame) - CGRectGetMidX(_selectedItem.frame);
    
    // Add the animation about translation
    CABasicAnimation *positionAnimation = [CABasicAnimation animation];
    positionAnimation.keyPath = @"position.x";
    positionAnimation.fromValue = @(_sliderView.layer.position.x);
    positionAnimation.toValue = @(_sliderView.layer.position.x + dx);
    positionAnimation.duration = 0.2;
    [_sliderView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];

//    // Add the animation about size
//    CABasicAnimation *boundsAnimation = [CABasicAnimation animation];
//    boundsAnimation.keyPath = @"bounds.size.width";
//    boundsAnimation.fromValue = @(CGRectGetWidth(_sliderView.layer.bounds));
//    boundsAnimation.toValue = @(CGRectGetWidth(item.frame));
//    
//    // Combine all the animations to a group
//    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//    animationGroup.animations = @[positionAnimation, boundsAnimation];
//    animationGroup.duration = 0.2;
//    [_sliderView.layer addAnimation:animationGroup forKey:@"basic"];
    
    
//     Keep the state after animating
    _sliderView.layer.position = CGPointMake(_sliderView.layer.position.x + dx, _sliderView.layer.position.y);
//    CGRect rect = _sliderView.layer.bounds;
//    rect.size.width = CGRectGetWidth(item.frame);
//    _sliderView.layer.bounds = rect;
}

#pragma mark - Public

- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback {
    _callback = callback;
}

- (void)selectSlideBarItemAtIndex:(NSUInteger)index {
    FDSlideBarItem *item = [self.items objectAtIndex:index];
    if (item == _selectedItem) {
        return;
    }
//    NSLog(@"selectSlideBarItemAtIndex %lu", (unsigned long)index);
    item.selected = YES;
    [self scrollToVisibleItem:item];
    [self addAnimationWithSelectedItem:item];
    self.selectedItem = item;
    if (index == 0) {
        self.leftImgV.hidden = YES;
        self.rightImgV.hidden = NO;
    }else if(index == self.items.count-1){
        self.leftImgV.hidden = NO;
        self.rightImgV.hidden = YES;
    }else{
        self.leftImgV.hidden = NO;
        self.rightImgV.hidden = NO;
    }
}

#pragma mark - FDSlideBarItemDelegate

- (void)slideBarItemSelected:(FDSlideBarItem *)item {
    if (item == _selectedItem) {
        return;
    }
    
    [self addAnimationWithSelectedItem:item];
    [self scrollToVisibleItem:item];
    self.selectedItem = item;
    NSInteger index = [self.items indexOfObject:item];
    if (index == 0) {
        self.leftImgV.hidden = YES;
        self.rightImgV.hidden = NO;
    }else if(index == self.items.count-1){
        self.leftImgV.hidden = NO;
        self.rightImgV.hidden = YES;
    }else{
        self.leftImgV.hidden = NO;
        self.rightImgV.hidden = NO;
    }

    _callback([self.items indexOfObject:item]);
}

@end
