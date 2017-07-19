//
//  JYMainViewCell.m
//  JYFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "JYMainViewCell.h"

@interface JYMainViewCell ()

@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation JYMainViewCell

- (instancetype)initWithStyle:(JYMainViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        _rowNumber = 1;
        _sectionNumber = 1;
        [self addLine];
        switch (style) {
            case JYMainViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textColor = JYColor_TextColor_Chief;
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                _titleLabel.font = [UIFont boldSystemFontOfSize:14];
                [self addSubview:_titleLabel];
            }
                break;
            case JYMainViewCellStyleCustom:
            {
                _style = style;
            }
                break;
            default:
                break;
        }
    }
    return self;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSeparatorStyle:(JYMainViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == JYMainViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    _leftLine.backgroundColor = lineGrayColor;
    _leftLine.hidden = YES;
    [self addSubview:_leftLine];
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    _rightLine.backgroundColor = lineGrayColor;
    _rightLine.hidden = YES;
    [self addSubview:_rightLine];
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, -0.5, self.frame.size.width, 0.5)];
    _topLine.backgroundColor = lineGrayColor;
    [self addSubview:_topLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    _bottomLine.backgroundColor = lineGrayColor;
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.leftLine removeFromSuperview];
    [self.rightLine removeFromSuperview];
    [self.topLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.leftLine setFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    [self.rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    [self.topLine setFrame:CGRectMake(0, -0.5, self.frame.size.width, 0.5)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.style == JYMainViewCellStyleDefault) {
        [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    if (self.separatorStyle == JYMainViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

@end
