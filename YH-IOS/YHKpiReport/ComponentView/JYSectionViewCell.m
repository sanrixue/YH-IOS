//
//  JYSectionViewCell.m
//  JYFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "JYSectionViewCell.h"
#import "JYBlockButton.h"

@interface JYSectionViewCell ()
@property (strong, nonatomic) UIView *leftLine;
@property (strong, nonatomic) UIView *rightLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) JYBlockButton *clickBtn;
@property (nonatomic, copy) void(^clickActive)(NSString *title);

@end

@implementation JYSectionViewCell

- (instancetype)initWithStyle:(JYSectionViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self addLine];
        switch (style) {
            case JYSectionViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_titleLabel];
            }
                break;
            case JYSectionViewCellStyleCustom:
            {
                _style = style;
            }
            default:
                break;
        }
        [self addSubview:self.clickBtn];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSeparatorStyle:(JYSectionViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == JYSectionViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (JYBlockButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
        __weak typeof(self) weakSelf = self;
        [_clickBtn setHandler:^(BOOL isSelected){
            weakSelf.clickActive(weakSelf.title);
        }];
    }
    return _clickBtn;
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    _leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    _leftLine.backgroundColor = lineGrayColor;
    [self addSubview:_leftLine];
    _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    _rightLine.backgroundColor = lineGrayColor;
    [self addSubview:_rightLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    _bottomLine.backgroundColor = [UIColor grayColor];
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.leftLine removeFromSuperview];
    [self.rightLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.leftLine setFrame:CGRectMake(0, 0, 0.5, self.frame.size.height)];
    [self.rightLine setFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.clickBtn.frame = self.bounds;
    if (self.style == JYSectionViewCellStyleDefault) {
        [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    if (self.separatorStyle == JYSectionViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

- (void)setClickedActive:(void (^)(NSString *))selectedActive {
    self.clickActive = selectedActive;
}

@end
