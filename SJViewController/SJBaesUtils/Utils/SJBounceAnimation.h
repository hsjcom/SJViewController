//
//  SJBounceAnimation.h
//
//
//  Created by Shaojie Hong on 14-5-28.
//  Copyright (c) 2014年 Shaojie Hong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum {
    SJBounceAnimationStiffnessLight,
    SJBounceAnimationStiffnessMedium,
    SJBounceAnimationStiffnessHeavy
} SJBounceAnimationStiffness;

@interface SJBounceAnimation : CAKeyframeAnimation

@property(nonatomic, strong) id fromValue;
@property(nonatomic, strong) id byValue;
@property(nonatomic, strong) id toValue;
@property(nonatomic, assign) NSUInteger numberOfBounces;
@property(nonatomic, assign) BOOL shouldOvershoot; //default YES
@property(nonatomic, assign) BOOL shake; //if shaking, set fromValue to the furthest value, and toValue to the current value
@property(nonatomic, assign) SJBounceAnimationStiffness stiffness;

+ (SJBounceAnimation *)animationWithKeyPath:(NSString *)keyPath;

@end
