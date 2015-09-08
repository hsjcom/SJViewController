//
//  SJTableViewCell.m
//  SoldierViewController
//
//  Created by Soldier on 15-2-3.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJTableViewCell.h"

@implementation SJTableViewItem
@synthesize delegate;
@synthesize selector;

- (void)dealloc{
    delegate = nil;
}

@end




@implementation SJTableViewCell

- (void)dealloc {
    [self setObject:nil];
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    return 44;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [[UIView alloc] init];
        bgView.frame = CGRectMake(0, 0, self.width, self.height);
        bgView.backgroundColor = RGBACOLOR(0, 0, 0, 0.1);
        self.selectedBackgroundView = bgView;
    }
    return self;
}

- (id)object {
    return nil;
}

- (void)prepareForReuse {
    self.object = nil;
    self.textLabel.text = nil;
    self.detailTextLabel.text = nil;
    [super prepareForReuse];
}

- (void)setObject:(id)object {
    if (!object) {
        return;
    }
}



@end
