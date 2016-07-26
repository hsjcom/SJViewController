//
//  SJSlidePageCell.m
//
//
//  Created by Soldier on 16/3/30.
//  Copyright © 2016年 厦门海豹信息技术. All rights reserved.
//

#import "SJSlidePageCell.h"
#import "SJSlidePageItemController.h"

@implementation SJSlidePageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];// COLOR_GRAY_BG;
        self.backgroundColor = [UIColor clearColor];//COLOR_GRAY_BG;
    }
    return self;
}

/**
 * 子类重写
 */
- (void)initWithQuery:(NSDictionary *)query
             delegate:(id)delegate
                index:(NSInteger)index {
    if (!_controller) {
        
    } else {
        [self.controller.view removeFromSuperview];
        _controller = nil;
    }
    
    SJSlidePageItemController *vc = [[SJSlidePageItemController alloc] initWithQuery:query];
    vc.view.frame = CGRectMake(0, 0, self.width, self.height);
    [self.contentView addSubview:vc.view];
    self.controller = vc;
    
    self.controller.spDelegate = delegate;
    [self.controller initialPageIndex:index];
    [self.controller initialQuery:query];
}

- (void)reloadDataWithMode:(SJSlidePageModel *)model{
    if (!model) {
        [self.controller refreshForNewData];
        return;
    }
    [self.controller reloadModel:model];
    self.controller.page = model.page > 0 ? model.page : 1;
    [self.controller onDataUpdated];
    
    if (model.contentOffsetY >= 0) {
        self.controller.tableView.contentOffset = CGPointMake(0, model.contentOffsetY);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.controller.view.frame = CGRectMake(0, 0, self.width, self.height);
    self.controller.tableView.frame = CGRectMake(0, 0, self.width, self.height);
}

@end
