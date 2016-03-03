//
//  UITableView+Add.h
//  
//
//  Created by Soldier on 15-2-6.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Add)

- (void)scrollToTop:(BOOL)animated;

- (void)scrollToBottom:(BOOL)animated;

- (void)scrollToFirstRow:(BOOL)animated;

- (void)scrollToLastRow:(BOOL)animated;

@end
