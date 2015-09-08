//
//  SJModel.h
//
//
//  Created by Soldier on 15-2-15.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SJModelViewController.h"

@interface SJModel : NSObject

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *msg;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) NSUInteger newItemsCount;
@property (nonatomic, weak) SJModelViewController *modelController;
@property (nonatomic) PullLoadType loadType;

- (void)loadMoreNewData;

- (void)loadMoreOldData;

@end
