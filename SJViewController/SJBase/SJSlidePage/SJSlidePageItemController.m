//
//  SJSlidePageItemController.m
//
//
//  Created by Soldier on 16/3/30.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "SJSlidePageItemController.h"

@implementation SJSlidePageItemController

/**
 * reload model 数据，根据子类的数据类型 重写
 */
- (void)reloadModel:(SJSlidePageModel *)model {
    if (!model) {
        return;
    }
}

/**
 * 重写onDataUpdated，调用 updatePageModel
 */

- (void)onDataUpdated {
    [super onDataUpdated];
    
//    if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(updatePageModel:)]) {
//        [self.spDelegate updatePageModel:self.model];
//    }
}

- (void)initialQuery:(NSDictionary *)query {
}

- (void)initialPageIndex:(NSInteger)index {
    self.pageIndex = index;
}

#pragma mark - UIScrollViewDelegate

/**
 * 子类重写 UIScrollViewDelegate 需要super方法
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    if (scrollView == self.tableView) {
        CGFloat currentPostion = scrollView.contentOffset.y;
        if (currentPostion - _lastPositionY > 20 && currentPostion > 0) {
            _lastPositionY = currentPostion;
            
//            NSLog(@"-----上滑-----");
            if (self.tableView.contentSize.height > self.tableView.height + 20) {
                if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollWithContentOffsetY:offset:)]) {
                    [self.spDelegate scrollWithContentOffsetY:currentPostion offset:0];
                }
            }
            
        } else if ((_lastPositionY - currentPostion > 20) && (currentPostion <= scrollView.contentSize.height - scrollView.bounds.size.height - 20) ){
            _lastPositionY = currentPostion;
            
//            NSLog(@"-----下滑-----");
            if (self.tableView.contentSize.height > self.tableView.height + 20) {
                if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollWithContentOffsetY:offset:)]) {
                    [self.spDelegate scrollWithContentOffsetY:currentPostion offset:1];
                }
            }
        }
//        if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollWithContentOffsetY:offset:)]) {
//            [self.spDelegate scrollWithContentOffsetY:scrollView.contentOffset.y offset:0];
//        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView && scrollView == self.tableView) {
        if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(updateContentOffset:)]) {
            [self.spDelegate updateContentOffset:scrollView.contentOffset.y];
        }
    }
}

@end
