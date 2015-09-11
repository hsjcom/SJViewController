//
//  SJTableViewDataSource.m
//  SoldierViewController
//
//  Created by Soldier on 15-2-3.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJTableViewDataSource.h"
#import "SJTableViewCell.h"
#import <objc/runtime.h>

@implementation SJTableViewDataSource

- (void)dealloc {
    [self setItems:nil];
}

- (id)initWithItems:(NSArray *)items {
    self = [self init];
    if (self) {
        self.items = [NSMutableArray arrayWithArray:items];
    }
    
    return self;
}

+ (SJTableViewDataSource *)dataSourceWithObjects:(id)object, ... {
    NSMutableArray *items = [NSMutableArray array];
    va_list ap;
    va_start(ap, object);
    while (object) {
        [items addObject:object];
        object = va_arg(ap, id);
    }
    va_end(ap);
    
    return [[self alloc] initWithItems:items];
}

/*
 * 适用于上面为items，下面为layout的数据格式
 */
+ (SJTableViewDataSource *)dataSourceWithItems:(NSMutableArray *)items andLayout:(id)layout {
    NSMutableArray *tempItems = [NSMutableArray array];
    [tempItems addObjectsFromArray:items];
    [self addToArray:tempItems value:layout];
    
    return [[self alloc] initWithItems:tempItems];
}

/*
 * 适用于上面为items，中间特殊ietm，下面为layout的数据格式
 */
+ (SJTableViewDataSource *)dataSourceWithItems:(NSMutableArray *)items separateItem:(id)separateItem andLayout:(id)layout {
    NSMutableArray *tempItems = [NSMutableArray array];
    [tempItems addObjectsFromArray:items];
    [self addToArray:tempItems value:separateItem];
    [self addToArray:tempItems value:layout];
    
    return [[self alloc] initWithItems:tempItems];
}

+ (SJTableViewDataSource *)dataSourceWithItems:(NSMutableArray *)items {
    return [[self alloc] initWithItems:items];
}

+ (void)addToArray:(NSMutableArray *)array value:(NSObject *)value{
    if (!array || ![array isKindOfClass:[NSMutableArray class]]) {
        return;
    }
    if (!value) {
        return;
    }
    [array addObject:value];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    
    Class cellClass = [self tableView:tableView cellClassForObject:object];
    const char *className = class_getName(cellClass);
    NSString *identifier = [[NSString alloc] initWithBytesNoCopy:(char *)className
                                                          length:strlen(className)
                                                        encoding:NSASCIIStringEncoding freeWhenDone:NO];
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:identifier];
    }
    
    if ([cell isKindOfClass:[SJTableViewCell class]]) {
        [(SJTableViewCell *) cell setObject:object];
    }
    
    [self tableView:tableView cell:cell willAppearAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark -


#pragma mark - SJTableViewDataSource

- (void)tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath {
}

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _items.count) {
        return [_items objectAtIndex:(NSUInteger) indexPath.row];
    } else {
        return nil;
    }
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    return [SJTableViewCell class];
}

- (NSIndexPath *)tableView:(UITableView *)tableView indexPathForObject:(id)object {
    NSUInteger objectIndex = [_items indexOfObject:object];
    if (objectIndex != NSNotFound) {
        return [NSIndexPath indexPathForRow:objectIndex inSection:0];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}


@end
