//
//  SJCollectionViewFooterView.m
//  
//
//  Created by Shaojie Hong on 15/4/13.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJCollectionViewFooterView.h"
#import "SJCollectionViewItem.h"

@implementation SJCollectionViewFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)object {
    return _object;
}

- (void)setObject:(id)object {
    if (object != _object) {
        _object = object;
    }
}

@end
