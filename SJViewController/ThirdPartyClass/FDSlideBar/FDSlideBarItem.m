//
//  FDSlideBarItem.m
//  FDSlideBarDemo
//
//  Created by fergusding on 15/6/4.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDSlideBarItem.h"

#define DEFAULT_TITLE_FONTSIZE 15
#define DEFAULT_TITLE_SELECTED_FONTSIZE 15
#define DEFAULT_TITLE_COLOR COLOR_TEXT_1
#define DEFAULT_TITLE_SELECTED_COLOR COLOR_TEXT_1

#define HORIZONTAL_MARGIN 14

@interface FDSlideBarItem ()

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat selectedFontSize;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *selectedColor;

@end

@implementation FDSlideBarItem

#pragma mark - Lifecircle

- (instancetype) init {
    if (self = [super init]) {
        _fontSize = DEFAULT_TITLE_FONTSIZE;
        _selectedFontSize = DEFAULT_TITLE_SELECTED_FONTSIZE;
        _color = DEFAULT_TITLE_COLOR;
        _selectedColor = DEFAULT_TITLE_SELECTED_COLOR;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat titleX = (CGRectGetWidth(self.frame) - [self titleSize].width) * 0.5;
    CGFloat titleY = (CGRectGetHeight(self.frame) - [self titleSize].height) * 0.5;
    
    CGRect titleRect = CGRectMake(titleX, titleY, [self titleSize].width, [self titleSize].height);
    NSDictionary *attributes = @{NSFontAttributeName : [self titleFont], NSForegroundColorAttributeName : [self titleColor]};
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:_title attributes:attributes];
    [attributedString drawInRect:titleRect];
//    [_title drawInRect:titleRect withAttributes:attributes];
}

#pragma mark - Custom Accessors

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Public

- (void)setItemTitle:(NSString *)title {
    _title = title;
    [self setNeedsDisplay];
}

- (void)setItemTitleFont:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setItemSelectedTileFont:(CGFloat)fontSize {
    _selectedFontSize = fontSize;
    [self setNeedsDisplay];
}

- (void)setItemTitleColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setItemSelectedTitleColor:(UIColor *)color {
    _selectedColor = color;
    [self setNeedsDisplay];
}

#pragma mark - Private

- (CGSize)titleSize {
    NSDictionary *attributes = @{NSFontAttributeName : [self titleFont]};
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:_title attributes:attributes];
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    CGSize size = [_title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    
    return size;
}

- (UIFont *)titleFont {
    UIFont *font;
    if (_selected) {
        font = [UIFont systemFontOfSize:_fontSize];
    } else {
        font = [UIFont systemFontOfSize:_fontSize];
    }
    return font;
}

- (UIColor *)titleColor {
//    UIColor *color;
//    if (_selected) {
//        color = _selectedColor;
//    } else {
//        color = _color;
//    }
    return COLOR_TEXT_1;
}

#pragma mark - Public Class Method

+ (CGFloat)widthForTitle:(NSString *)title {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:DEFAULT_TITLE_FONTSIZE]};
//    CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:title attributes:attributes];
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    size.width = ceil(size.width) + HORIZONTAL_MARGIN * 2;
    
    return size.width;
}

#pragma mark - Responder

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.selected = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideBarItemSelected:)]) {
        [self.delegate slideBarItemSelected:self];
    }
}

@end
