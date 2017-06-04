//
//  YH_BarView.m
//  SwiftCharts
//
//  Created by CJG on 17/4/6.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "YH_BarView.h"

@interface YH_BarView ()
@property (nonatomic, strong) UIView* barView;
@end

@implementation YH_BarView

- (UIView *)barView{
    if (!_barView) {
        _barView = [[UIView alloc] init];
    }
    return _barView;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.barView];
        self.barColor = [UIColor clearColor];
        [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self).multipliedBy(0.000001);
        }];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addSubview:self.barView];
        self.barColor = [UIColor clearColor];
        [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(self);
            make.width.mas_equalTo(self).multipliedBy(0.000001);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.barView.width = self.width*_scale;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    [UIView animateWithDuration:0.3 animations:^{
        //        [self.barView mas_updateConstraints:^(MASConstraintMaker *make) {
        //            make.width.mas_equalTo(self).multipliedBy(self.scale);
        //        }];
        //        [self layoutIfNeeded];
        self.barView.width = self.width*scale;
    }];
}

- (void)setBarColor:(UIColor *)barColor{
    _barColor = barColor;
    _barView.backgroundColor = barColor;
}

@end
