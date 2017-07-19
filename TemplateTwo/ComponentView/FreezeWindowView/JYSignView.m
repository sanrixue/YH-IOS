//
//  JYFreezeView.m
//  JYFreezeWindowView
//
//  Created by niko on 17/5/4.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "JYSignView.h"

@interface JYSignView ()

@property (strong, nonatomic) UILabel *contentLabel;
@property (nonatomic, strong) UIView *rightLine;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation JYSignView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *whiteBG = [[UIView alloc] initWithFrame:CGRectMake(-JYDefaultMargin * 2, 0, JYViewWidth + JYDefaultMargin * 2, JYViewHeight)];
        whiteBG.backgroundColor = JYColor_BackgroudColor_SubWhite;
        [self addSubview:whiteBG];
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, frame.size.height / 4, frame.size.width - 7, frame.size.height / 2)];
        _contentLabel.textColor = JYColor_TextColor_Chief;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_contentLabel];
        
        [self addSubview:self.rightLine];
        [self addSubview:self.bottomLine];
        self.backgroundColor = JYColor_BackgroudColor_SubWhite;
    }
    return self;
}

- (UIView *)rightLine {
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 0.5, self.frame.size.height)];
        _rightLine.backgroundColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    }
    return _rightLine;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(-JYDefaultMargin * 2, self.frame.size.height - 0.5, self.frame.size.width + JYDefaultMargin * 2, 0.5)];
        _bottomLine.backgroundColor = [UIColor colorWithRed:205./255. green:205./255. blue:205./255. alpha:1];
    }
    return _bottomLine;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}

@end
