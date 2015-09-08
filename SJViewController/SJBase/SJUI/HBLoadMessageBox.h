//
//  HBLoadMessageBox.h
//  
//
//  Created by Soldier on 14-3-3.
//  Copyright (c) 2014年 Soldier. All rights reserved.
//

#import "HBMessageBox.h"

@interface HBLoadMessageBox : HBMessageBox {
    NSString *_finishText;
}


- (id)initWithLoadingText:(NSString *)loadingText
            andFinishText:(NSString *)finishText;

- (void)finish;

- (id)initWithLoadingText:(NSString *)loadingText;

- (void)finishWithMessage:(NSString *)finishMsg;

@end
