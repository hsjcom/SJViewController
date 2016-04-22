//
//  HBModel.m
//  
//
//  Created by Soldier on 15-2-15.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJModel.h"

@implementation SJModel

- (void)dealloc{
    self.modelController = nil;
}

- (id)init{
    self = [super init];
    if (self) {
        _items = [NSMutableArray new];
    }
    return self;
}

- (void)loadMoreNewData{
    
}

- (void)loadMoreOldData{
    
}

@end
