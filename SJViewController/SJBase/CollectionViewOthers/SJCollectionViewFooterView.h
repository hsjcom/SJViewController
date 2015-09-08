//
//  SJCollectionViewFooterView.h
//  
//
//  Created by Shaojie Hong on 15/4/13.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

@class SJCollectionViewItem;

@interface SJCollectionViewFooterView : UICollectionReusableView{
    SJCollectionViewItem *_object;
}

- (id)object;

- (void)setObject:(id)object;

@end
