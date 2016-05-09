//
//  SJSlidePageItemController.h
//
//
//  Created by Soldier on 16/3/30.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "SJTableViewController.h"
#import "SJSlidePageController.h"
#import "SJSlidePageModel.h"

/**
 * 注意
 * viewDidLoad 里不能调 createModel
 */

@interface SJSlidePageItemController : SJTableViewController {
    CGFloat _lastPositionY;
}

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, weak) id<SJSlidePageDelegate> spDelegate;

/**
 * @require
 * reload model 数据，根据子类的数据类型 重写
 */
- (void)reloadModel:(SJSlidePageModel *)model;

/**
 * @require
 */
- (void)initialPageIndex:(NSInteger)index;

- (void)initialQuery:(NSDictionary *)query;

@end
