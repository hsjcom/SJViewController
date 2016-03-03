//
//  NSData+SJ.h
//  
//
//  Created by Soldier on 15-1-30.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SJ)

- (NSString *)md5Hash;

- (NSString *)sha1Hash;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

- (NSString *)base64Encoding;

@end
