//
//  SJTableViewCell.h
//  SoldierViewController
//
//  Created by Soldier on 15-2-3.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJTableViewItem : NSObject

@property(nonatomic, weak) id delegate;
@property(nonatomic, assign) SEL selector;

@end





@interface SJTableViewCell : UITableViewCell

@property (nonatomic, strong) id object;

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object;

@end
