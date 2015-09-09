//
//  CommonDefine.h
// 
//
//  Created by Shaojie Hong on 15/2/9.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

typedef NS_ENUM(int, SJTabState) {
    Tab_Mall      = 0,
    Tab_Category  = 1,
    Tab_Fourm     = 2,
    Tab_ShopCart  = 3,
    Tab_Mine      = 4
};

#define ITUNES_APP_PREFIX          @"itms-apps://"
#define ITUNES_PREFIX              @"itms://"

#define ITUNES_APP_SECURE_PREFIX   @"itms-appss://"
#define ITUNES_SECURE_PREFIX       @"itmss://"

#define HTTP_PREFIX       @"http://"
#define HTTPS_PREFIX       @"https://"


#pragma mark - common define
/**
 * 常用宏
 */

#define AppDelegateInstance [[UIApplication sharedApplication] delegate]
#define SJ_TopView    [AppDelegateInstance window].rootViewController.view
#define SJ_Keywindow  [AppDelegateInstance window]

#define UI_SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define OSVersion()    [[[UIDevice currentDevice] systemVersion] floatValue]
#define OnePixelLineHeight  (1.0 / [[UIScreen mainScreen] scale])

#define IsiOS8() (OSVersion() >= 8.0)
#define IsiOS7() (OSVersion() >= 7.0)
#define IsNotiOS7() (OSVersion() < 7.0)
#define IsiPad() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IsiPhone6() ([[UIScreen mainScreen] bounds].size.width >= 750/2 ? YES : NO)
#define Is3dot5Inch() (UI_SCREEN_HEIGHT <= 480 ? YES : NO)

#define isRetina ([[UIScreen mainScreen] scale] >= 2 ? YES : NO)

#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

#define Bunndle_AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
#define RELEASE_DISPATCH_SOURCE(__POINTER) {dispatch_source_cancel(__POINTER); _dispatch_object_validate(__POINTER); __POINTER = nil;}
#define RELEASE_SAFELY(__POINTER) {__POINTER = nil;}
#define RELEASE_VIEW_SAFELY(__POINTER) {[__POINTER removeFromSuperview]; __POINTER = nil; }
#define RELEASE_LAYER_SAFELY(__POINTER) {[__POINTER removeFromSuperlayer]; __POINTER = nil; }
#define RELEASE_REQ(__POINTER){[__POINTER clearDelegatesAndCancel];__POINTER = nil;}

#define SafeCallSelector(instance,selector)  if (instance && [instance respondsToSelector:selector]) { SafePerformSelector([instance performSelector:selector]);}

#define SafePerformSelector(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define DefaultGrayImgName @"gray.png"
#define DefaultGrayImage [UIImage imageNamed:@"gray.png"]

#define ShowMessageBoxTime       2
#define ShowMessageBoxTitle      17
#define ShowMessageBoxContent    15

//图片渐显动画出现的时间
#define ImgAppearTime 0.4
#define ImgDisAppearTime 0.4

