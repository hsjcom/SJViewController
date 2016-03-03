//
//  ValueValidator.h
//
//
//  Created by Soldier on 12-5-9.
//  Copyright (c) 2012年 Soldier. All rights reserved.
//


@interface ValueValidator : NSObject {

}
+ (BOOL)isNSNull:(NSDictionary *)responseDict key:(NSString *)key;

+ (BOOL)isNuLLForArray:(NSArray *)array;

+ (BOOL)isNuLLForSet:(NSSet *)set;

@end
