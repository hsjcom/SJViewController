//
//  SJTableViewCell.h
//  SoldierViewController
//
//  Created by Soldier on 15-2-3.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Cell侧滑时通知相关
 */
#define SJSwipeTableViewCellDidHideContextMenu @"SJSwipeTableViewCellDidHideContextMenu"
#define SJSwipeTableViewCellDidShowContextMenu @"SJSwipeTableViewCellDidShowContextMenu"
#define SJSwipeTableViewCellWillHideContextMenu @"SJSwipeTableViewCellWillHideContextMenu"
#define SJSwipeTableViewCellWillShowContextMenu @"SJSwipeTableViewCellWillShowContextMenu"
#define SJSwipeTableViewCellMenuDidSelectItem @"SJSwipeTableViewCellMenuDidSelectItem"

#define SJTableViewCellSwipeMenuItemIndexKey @"index"

#define kSJSwipeMenuItemTagOffSet 20151101
#define kSJSwipeMenuItemIndex(MenuBtn) ([MenuBtn tag] - kSJSwipeMenuItemTagOffSet)


@interface SJSwipeMenuItem : NSObject

@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *hlBgColor; // 若没设置，则高亮时跟bgColor一样
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat width;

- (instancetype)initWithBgColor:(UIColor *)bgColor hlBgColor:(UIColor *)hlBgColor font:(UIFont *)font titleColor:(UIColor *)titleColor title:(NSString *)title width:(CGFloat)width;

@end





@interface SJTableViewCell : UITableViewCell

@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;


/**
 * Cell侧滑相关
 */
// readme: 如果需要支持左滑轻扫，需要把Subview add在 actualContentView 而不是contentView(内部存放了actualContentView和contextMenuView)，如有特殊需求，自行在子类中修改actualContentView的frame

@property (nonatomic, strong) UIView *actualContentView;
@property (nonatomic, strong) UIView *contextMenuView;

@property (nonatomic, assign) CGFloat menuOptionsAnimationDuration; //默认0.3
@property (nonatomic, assign) CGFloat bounceValue; //默认30

/**
 *  是否支持左滑轻扫出来的菜单
 *  @return default:NO
 */
- (BOOL)canSwipeMenu;

/**
 *  如果在子类实现canSwipeMenu返回YES,则必须实现下面的方法，用来构建菜单
 *  @return 数组，内部存放的是HBSwipeMenuItem的实例
 */
- (NSArray <SJSwipeMenuItem *> *)getSwipeMenuItemsFroContrustContextMenuView;

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;

@end
