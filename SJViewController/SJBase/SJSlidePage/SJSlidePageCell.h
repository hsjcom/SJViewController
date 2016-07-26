//
//  SJSlidePageCell.h
//  
//
//  Created by Soldier on 16/3/30.
//  Copyright © 2016年 厦门海豹信息技术. All rights reserved.
//

#import "SJCollectionViewCell.h"
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
