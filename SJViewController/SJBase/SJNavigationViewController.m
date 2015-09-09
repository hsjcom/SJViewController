//
//  SJNavigationViewController.m
//
//
//  Created by Shaojie Hong on 15-1-27.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJNavigationViewController.h"

@interface SJNavigationViewController () {
    CGPoint _startTouch;
    UIImageView *_lastScreenShotView;
    UIView *_blackMask;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign) CGFloat startBackViewX;
@property (nonatomic, assign) BOOL isMoving;

@end




@implementation SJNavigationViewController

- (void)dealloc {
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IsiOS7()) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (IsiOS7()) {
        UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
        recognizer.delegate = self;
        recognizer.edges = UIRectEdgeLeft;
        recognizer.delaysTouchesBegan = YES;
        [self.view addGestureRecognizer:recognizer];
    } else {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
        recognizer.delegate = self;
        recognizer.delaysTouchesBegan = YES;
        [recognizer delaysTouchesBegan];
        [self.view addGestureRecognizer:recognizer];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:(BOOL)animated];
    
    if (!IsiOS7()) {
        return;
    }
    
    if (self.screenShotsList.count == 0) {
        UIImage *capturedImage = [self capture];
        if (capturedImage) {
            [self.screenShotsList addObject:capturedImage];
        }
    }
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIImage *capturedImage = [self capture];
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
        
        //* HBMultiSelectPhotoViewController  中间会插入HBAlbumsPickerController
        if ([viewController isKindOfClass:NSClassFromString(@"HBMultiSelectPhotoViewController")]) {
            [self.screenShotsList addObject:capturedImage];
        }
    }
    
    if (IsiOS7()) {
        [super pushViewController:viewController animated:NO];
        //    5 大主页面 push 时不执行动画
        UIViewController* root = [self.viewControllers objectAtIndex:0];
        if (![root isEqual:viewController] && animated) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.5;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            transition.delegate = self;
            [self.view.layer addAnimation:transition forKey:nil];
        }
    }else{
        [super pushViewController:viewController animated:YES];
    }

}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    [self.screenShotsList removeLastObject];

    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    NSArray *popedVCs = [super popToRootViewControllerAnimated:animated];
    for (int i = 0; i < [popedVCs count]; i++) {
        [self.screenShotsList removeLastObject];
    }
    
    return popedVCs;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *popedVCs = [super popToViewController:viewController animated:animated];
    for (int i = 0; i < [popedVCs count]; i++) {
        [self.screenShotsList removeLastObject];
    }
    
    return popedVCs;
}

#pragma mark - Utility Methods

// get the current view screen shot
- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT), NO, 0.0);
    
    if (IsiOS7()) {
        [SJ_TopView drawViewHierarchyInRect:SJ_TopView.bounds afterScreenUpdates:NO];
    }else{
        [SJ_TopView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x {
//    NSLog(@"Move to:%f",x);
    
    x = x > UI_SCREEN_WIDTH ? UI_SCREEN_WIDTH : x;
    x = x < 0 ? 0 : x;
    
    CGRect frame = SJ_TopView.frame;
    frame.origin.x = x;
    SJ_TopView.frame = frame;
    
    CGFloat y = x * (fabs(_startBackViewX) / UI_SCREEN_WIDTH);
    [_lastScreenShotView setFrame:CGRectMake(_startBackViewX + y, 0, _lastScreenShotView.width, _lastScreenShotView.height)];
    
    float alphaValue = 0.2 - (x / 1800);
    float alpha = alphaValue < 0 ? 0 : alphaValue;
    _blackMask.alpha = alpha;
    
//    float scale = (x / 6400) + 0.95;
//    _lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1) return NO;
    SJViewController *topView = (SJViewController *)[SJNavAction getCurrentViewController];
    if (![topView canDragBack]) return NO;
    return YES;
}

#pragma mark - Gesture Recognizer

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1) return;
    SJViewController *topView = (SJViewController *)[SJNavAction getCurrentViewController];
    if (![topView canDragBack]) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:SJ_Keywindow];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        _startTouch = touchPoint;
        
        [self createBGViewAndLastScreenShotView];
        
        SJ_TopView.layer.shadowRadius = 2;
        SJ_TopView.layer.shadowOpacity = 0.3;
        SJ_TopView.layer.shadowPath = [UIBezierPath bezierPathWithRect:SJ_TopView.bounds].CGPath;
    }
    
    //End paning, always check that if it should move right or move left automatically
    else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - _startTouch.x > 50) {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:UI_SCREEN_WIDTH];
            } completion:^(BOOL finished) {
                
                SJViewController *topView = (SJViewController *)[SJNavAction getCurrentViewController];
                [topView backViewForSideslip];
                
                CGRect frame = SJ_TopView.frame;
                frame.origin.x = 0;
                SJ_TopView.frame = frame;
                
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
        }
        return;
    }
    
    // cancal panning, alway move to left side automatically
    else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - _startTouch.x];
    }
}

- (void)createBGViewAndLastScreenShotView {
    if (!self.backgroundView || !self.backgroundView.superview) {
        CGRect frame = SJ_TopView.frame;
        
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        [SJ_TopView.superview insertSubview:self.backgroundView belowSubview:SJ_TopView];
        
        _blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _blackMask.backgroundColor = [UIColor blackColor];
        [self.backgroundView addSubview:_blackMask];
        
        _lastScreenShotView = nil;
    }
    
    self.backgroundView.hidden = NO;
    
    _startBackViewX = -200;
    
    if (_lastScreenShotView) RELEASE_VIEW_SAFELY(_lastScreenShotView);
    UIImage *lastScreenShot = [self.screenShotsList lastObject];
    _lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    _lastScreenShotView.backgroundColor = [UIColor whiteColor];
    [_lastScreenShotView setFrame:CGRectMake(_startBackViewX, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    [self.backgroundView insertSubview:_lastScreenShotView belowSubview:_blackMask];
}

//自定义返回方法
- (void)customPopViewController {
    UIImage *lastScreenShot = [self.screenShotsList lastObject];
    if (!lastScreenShot) {
        [self popViewControllerAnimated:YES];
        return;
    }
    
    [self createBGViewAndLastScreenShotView];
    
    _blackMask.alpha = 0.1;
    [UIView animateWithDuration:0.4 animations:^{
        [self moveViewWithX:UI_SCREEN_WIDTH];
    } completion:^(BOOL finished) {
        
        SJViewController *topView = (SJViewController *)[SJNavAction getCurrentViewController];
        [topView backViewForSideslip];
        
        CGRect frame = SJ_TopView.frame;
        frame.origin.x = 0;
        SJ_TopView.frame = frame;
        
        self.backgroundView.hidden = YES;
    }];
}


@end
