//
//  JYFreezeViewCell.m
//  各种报表
//
//  Created by niko on 17/5/6.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYFreezeViewCell.h"
#import "JYBlockButton.h"

@interface JYFreezeViewCell ()

@property (strong, nonatomic) UIView *topLine;
@property (strong, nonatomic) UIView *bottomLine;
@property (strong, nonatomic) UILabel *titleLabel;
@property (nonatomic, strong) JYBlockButton *clickBtn;
@property (nonatomic, copy) void(^clickActive)(NSString *title);

@end

@implementation JYFreezeViewCell

- (instancetype)initWithStyle:(JYFreezeViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self addLine];
        switch (style) {
            case JYFreezeViewCellStyleDefault:
            {
                _style = style;
                _titleLabel = [[UILabel alloc] init];
                _titleLabel.textAlignment = NSTextAlignmentCenter;
                [self addSubview:_titleLabel];
            }
                break;
            case JYFreezeViewCellStyleCustom:
            {
                _style = style;
            }
                break;
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

- (void)setSeparatorStyle:(JYRowViewCellSeparatorStyle)separatorStyle {
    _separatorStyle = separatorStyle;
    if (separatorStyle == JYFreezeViewCellSeparatorStyleNone) {
        [self removeLine];
    }
}

- (JYBlockButton *)clickBtn {
    if (!_clickBtn) {
        _clickBtn = [JYBlockButton buttonWithType:UIButtonTypeCustom];
        __weak typeof(self) weakSelf = self;
        [_clickBtn setHandler:^(BOOL isSelected) {
            __strong typeof(weakSelf) inStrongSelf = weakSelf;
            if (inStrongSelf.clickActive) {
                inStrongSelf.clickActive(inStrongSelf.title);
            }
        }];
    }
    return _clickBtn;
}

- (void)addLine {
    UIColor *lineGrayColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    _topLine.backgroundColor = lineGrayColor;
    [self addSubview:_topLine];
    _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
    _bottomLine.backgroundColor = lineGrayColor;
    [self addSubview:_bottomLine];
}

- (void)removeLine {
    [self.topLine removeFromSuperview];
    [self.bottomLine removeFromSuperview];
}

- (void)setLine {
    [self.topLine setFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    [self.bottomLine setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.clickBtn.frame = self.bounds;
    if (self.style == JYFreezeViewCellStyleDefault) {
        [self.titleLabel setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    if (self.separatorStyle == JYFreezeViewCellSeparatorStyleSingleLine) {
        [self setLine];
    }
}

- (void)setClickedActive:(void (^)(NSString *))selectedActive {
    self.clickActive = selectedActive;
}


@end
