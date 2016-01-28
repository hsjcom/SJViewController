//
//  UrlManager.m
//  LifeStore
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "UrlManager.h"

@implementation UrlManager

+ (id)shareManager {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UrlManager alloc] initURL];
        
    });
    
    return sharedInstance;
}

- (id)initURL {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
