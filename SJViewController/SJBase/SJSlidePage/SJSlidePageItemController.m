//
//  SJSlidePageItemController.m
//
//
//  Created by Soldier on 16/3/30.
//  Copyright © 2016年 厦门海豹信息技术. All rights reserved.
//

#import "SJSlidePageItemController.h"

@implementation SJSlidePageItemController

/**
 * reload model 数据，根据子类的数据类型 重写
 * viewDidLoad 里不能调 createModel
 */
- (void)reloadModel:(SJSlidePageModel *)model {
    if (!model) {
        return;
    }
}

/**
 * @require
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
                if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollViewDidScrollWithContentOffsetY:offset:)]) {
                    [self.spDelegate scrollViewDidScrollWithContentOffsetY:currentPostion offset:0];
                }
            }
            
        } else if ((_lastPositionY - currentPostion > 20) && (currentPostion <= scrollView.contentSize.height - scrollView.bounds.size.height - 20) ){
            _lastPositionY = currentPostion;
            
//            NSLog(@"-----下滑-----");
//            if (self.tableView.contentSize.height > self.tableView.height + 20) {
                if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollViewDidScrollWithContentOffsetY:offset:)]) {
                    [self.spDelegate scrollViewDidScrollWithContentOffsetY:currentPostion offset:1];
                }
//            }
        }
//        if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollViewDidScrollWithContentOffsetY:offset:)]) {
//            [self.spDelegate scrollViewDidScrollWithContentOffsetY:scrollView.contentOffset.y offset:0];
//        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
    if (scrollView == self.tableView) {
        CGPoint point = [scrollView.panGestureRecognizer translationInView:scrollView];
        CGFloat currentPostion = scrollView.contentOffset.y;
        if (point.y < 0) { //上滑
            if (self.tableView.contentSize.height > self.tableView.height + 20) {
                if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollWithContentOffsetY:offset:)]) {
                    [self.spDelegate scrollWithContentOffsetY:currentPostion offset:0];
                }
            }
        } else { //下滑
            if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(scrollWithContentOffsetY:offset:)]) {
                [self.spDelegate scrollWithContentOffsetY:currentPostion offset:1];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView && scrollView == self.tableView) {
        if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(updateContentOffset:)]) {
            [self.spDelegate updateContentOffset:scrollView.contentOffset.y];
        }
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView && scrollView == self.tableView) {
//        if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(updateContentOffset:)]) {
//            [self.spDelegate updateContentOffset:scrollView.contentOffset.y];
//        }
//    }
//}

- (void)beginPullDownRefreshing {
    [super beginPullDownRefreshing];
    if (self.spDelegate && [self.spDelegate respondsToSelector:@selector(itemControllBeginPullDownRefreshing)]) {
        [self.spDelegate itemControllBeginPullDownRefreshing];
    }
}

@end
