//
//  SJSlidePageCell.h
//
//
//  Created by Soldier on 16/3/30.
//  Copyright © 2016年 Shaojie Hong. All rights reserved.
//

#import "SJSlidePageItemController.h"
#import "SJSlidePageModel.h"

@interface SJSlidePageCell : UICollectionViewCell

@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, strong) SJSlidePageItemController *controller;

- (void)initWithQuery:(NSDictionary *)query
             delegate:(id)delegate
                index:(NSInteger)index;

- (void)reloadDataWithMode:(SJSlidePageModel *)model;

@end
