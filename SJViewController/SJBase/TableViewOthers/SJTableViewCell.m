//
//  SJTableViewCell.m
//  SoldierViewController
//
//  Created by Soldier on 15-2-3.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJTableViewCell.h"

@implementation SJSwipeMenuItem

- (instancetype)initWithBgColor:(UIColor *)bgColor hlBgColor:(UIColor *)hlBgColor font:(UIFont *)font titleColor:(UIColor *)titleColor title:(NSString *)title width:(CGFloat)width{
    if (self = [super init]) {
        self.bgColor = bgColor;
        self.hlBgColor = hlBgColor;
        self.font = font;
        self.title = title;
        self.titleColor = titleColor;
        self.width = width;
    }
    return self;
}

@end





@interface SJTableViewCell ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (nonatomic, assign) BOOL shouldDisplayContextMenuView;
@property (nonatomic, assign) CGFloat initialTouchPositionX;
@property (nonatomic, assign) CGFloat allMenuOptionButtonWidth;
@property (nonatomic, weak) UIView *panView;

@end




@implementation SJTableViewCell

- (void)dealloc {
//    [self setObject:nil];
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 44;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, self.width, self.height);
        bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
        self.selectedBackgroundView = bgView;
        
        [self configSwipeCell];
    }
    return self;
}

- (void)configSwipeCell {
    if ([self canSwipeMenu]) {
        self.contextMenuView = [[UIView alloc] initWithFrame:self.actualContentView.bounds];
        self.contextMenuView.backgroundColor = self.contentView.backgroundColor;
        [self.contentView insertSubview:self.contextMenuView belowSubview:self.actualContentView];
        self.contextMenuHidden = self.contextMenuView.hidden = YES;
        self.shouldDisplayContextMenuView = NO;
        self.menuOptionsAnimationDuration = 0.3;
        self.bounceValue = 30.;
        [self constructMenuViewItems];
        // 为了支持侧滑返回
        UIView *panView = [[UIView alloc]init];
        panView.userInteractionEnabled = YES;
        panView.backgroundColor = [UIColor clearColor];
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panRecognizer.delegate = self;
        [panView addGestureRecognizer:panRecognizer];
        [self.contentView addSubview:panView];
        self.panView = panView;
        [self setNeedsLayout];
    }
}

- (id)object {
    return nil;
}

- (void)prepareForReuse {
    self.object = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    if (!object) {
        return;
    }
}

#pragma mark - 侧滑相关
/**
 * 侧滑相关
 */
- (BOOL)canSwipeMenu{
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.contextMenuHidden &&[self canSwipeMenu]) {
        self.contextMenuView.hidden = YES;
        [super setSelected:selected animated:animated];
    } else {
        [super setSelected:selected animated:animated];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.contextMenuHidden &&[self canSwipeMenu]) {
        self.contextMenuView.hidden = YES;
        [super setHighlighted:highlighted animated:animated];
    } else {
        [super setHighlighted:highlighted animated:animated];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if ([self canSwipeMenu]) {
        self.panView.frame = CGRectMake(60, 0, self.contentView.width-60, self.contentView.height);
        self.actualContentView.frame = self.contentView.bounds;
        self.contextMenuView.frame = self.actualContentView.frame;
        NSArray *itemsArr = [self getSwipeMenuItemsFroContrustContextMenuView];
        CGFloat x = self.width - self.allMenuOptionButtonWidth;
        for (int i = 0 ; i < itemsArr.count; i ++) {
            UIButton *btn = [self.contextMenuView viewWithTag:kSJSwipeMenuItemTagOffSet + i];
            btn.left = x;
            btn.height = self.contextMenuView.height;
            x = btn.right;
        }
    }
}

- (void)constructMenuViewItems{
    NSArray *itemsArr = [self getSwipeMenuItemsFroContrustContextMenuView];
    for (int i = 0 ; i < itemsArr.count; i ++) {
        SJSwipeMenuItem *item = itemsArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kSJSwipeMenuItemTagOffSet + i;
        btn.titleLabel.font = item.font;
        [btn setTitleColor:item.titleColor forState:UIControlStateNormal];
        [btn setTitle:item.title forState:UIControlStateNormal];
        btn.width = item.width;
//        self.allMenuOptionButtonWidth += btn.width;
        [btn setBackgroundImage:[UIImage imageWithColor:item.bgColor] forState:UIControlStateNormal];
        if (item.hlBgColor) {
            [btn setBackgroundImage:[UIImage imageWithColor:item.hlBgColor] forState:UIControlStateHighlighted];
        }else{
            [btn setBackgroundImage:[UIImage imageWithColor:item.bgColor] forState:UIControlStateHighlighted];
        }
        [btn addTarget:self action:@selector(menuItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contextMenuView addSubview:btn];
    }
}

- (void)menuItemBtnClick:(UIButton *)sender{
    NSInteger index = kSJSwipeMenuItemIndex(sender);
    NSDictionary *dict = @{SJTableViewCellSwipeMenuItemIndexKey:@(index)};
    [[NSNotificationCenter defaultCenter]postNotificationName:SJSwipeTableViewCellMenuDidSelectItem object:self userInfo:dict];
}

- (NSArray<SJSwipeMenuItem *> *)getSwipeMenuItemsFroContrustContextMenuView {
    return @[];
}

- (void)tableViewCellSwipeMenuDidSelectItem:(SJSwipeMenuItem *)item index:(NSInteger)index {
    
}

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler {
    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    CGRect frame = CGRectMake((hidden) ? 0 : -self.allMenuOptionButtonWidth, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:(animated) ? self.menuOptionsAnimationDuration : 0.
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
         self.actualContentView.frame = frame;
     } completion:^(BOOL finished) {
         self.contextMenuHidden = hidden;
         self.shouldDisplayContextMenuView = !hidden;
         if (!hidden) {
             [[NSNotificationCenter defaultCenter] postNotificationName:SJSwipeTableViewCellDidShowContextMenu object:self];
             self.panView.width -= self.allMenuOptionButtonWidth; //为了防止 侧滑出现时不能侧滑菜单不能点击
             
         } else {
             [[NSNotificationCenter defaultCenter] postNotificationName:SJSwipeTableViewCellDidHideContextMenu object:self];
             self.panView.width = self.contentView.width-60;
         }
         if (completionHandler) {
             completionHandler();
         }
     }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        
        CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
        CGFloat currentTouchPositionX = currentTouchPoint.x;
        CGPoint velocity = [recognizer velocityInView:self.contentView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.initialTouchPositionX = currentTouchPositionX;
            if (velocity.x > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SJSwipeTableViewCellWillHideContextMenu object:self];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:SJSwipeTableViewCellWillShowContextMenu object:self];
            }
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint velocity = [recognizer velocityInView:self.contentView];
            if (!self.contextMenuHidden || (velocity.x > 0. )||[self canSwipeMenu]) {
                if (self.selected) {
                    [self setSelected:NO animated:NO];
                }
                self.contextMenuView.hidden = NO;
                CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;
                self.initialTouchPositionX = currentTouchPositionX;
                CGFloat minOriginX = -self.allMenuOptionButtonWidth - self.bounceValue;
                CGFloat maxOriginX = 0.;
                CGFloat originX = CGRectGetMinX(self.actualContentView.frame) + panAmount;
                originX = MIN(maxOriginX, originX);
                originX = MAX(minOriginX, originX);
                
                if ((originX < -0.5 * self.allMenuOptionButtonWidth && velocity.x < 0.) || velocity.x < -100) {
                    self.shouldDisplayContextMenuView = YES;
                } else if ((originX > -0.3 * self.allMenuOptionButtonWidth && velocity.x > 0.) || velocity.x > 100) {
                    self.shouldDisplayContextMenuView = NO;
                }
                self.actualContentView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            [self setMenuOptionsViewHidden:!self.shouldDisplayContextMenuView animated:YES completionHandler:nil];
        }
    }
}

- (CGFloat)allMenuOptionButtonWidth {
    _allMenuOptionButtonWidth = 0.0f;
    for (UIButton *btn in self.contextMenuView.subviews) {
        _allMenuOptionButtonWidth += btn.width;
    }
    return _allMenuOptionButtonWidth;
}

- (UIView *)actualContentView{
    if (!_actualContentView) {
        _actualContentView = [[UIView alloc]initWithFrame:self.contentView.bounds];
        _actualContentView.backgroundColor = self.contentView.backgroundColor;
        [self.contentView addSubview:_actualContentView];
    }
    return _actualContentView;
}

#pragma mark - UIPanGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}





@end
