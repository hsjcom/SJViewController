//
//  SJNavigationViewController.h
//  
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJViewController.h"


@interface SJNavigationViewController : UINavigationController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *screenShotsList;

- (void)customPopViewController;

@end
