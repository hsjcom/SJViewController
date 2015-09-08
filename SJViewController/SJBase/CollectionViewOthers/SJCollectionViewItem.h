//
//  SJCollectionViewItem.h
//  
//
//  Created by Shaojie Hong on 15/3/4.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJCollectionViewItem : NSObject

@property (nonatomic, weak) id  delegate;
@property (nonatomic, assign) SEL selector;

@end