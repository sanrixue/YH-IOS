//
//  SDCollectionViewCell.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//



#import "SDCollectionViewCell.h"
#import "UIView+SDExtension.h"

@implementation SDCollectionViewCell



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self addSubview:imageView];
}

- (void)setupTitleLabel
{
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"好人一生平安";
    _titleLabel.hidden = NO;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    
    self.valueLable = [UILabel new];
    self.valueLable.backgroundColor = [UIColor clearColor];
    self.valueLable.textColor = [UIColor whiteColor];
    self.valueLable.font = [UIFont systemFontOfSize:51.5];
    self.valueLable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.valueLable];
    
    self.numberTitleLabel = [UILabel new];
    self.numberTitleLabel.backgroundColor = [UIColor clearColor];
    self.numberTitleLabel.textColor = [UIColor whiteColor];
    self.numberTitleLabel.font = [UIFont systemFontOfSize:15];
    self.numberTitleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.numberTitleLabel];
    
    self.numberValueLable = [UILabel new];
    self.numberValueLable.backgroundColor = [UIColor clearColor];
    self.numberValueLable.textColor  = [UIColor whiteColor];
    self.numberValueLable.font  = [UIFont systemFontOfSize:15];
    self.numberValueLable.textAlignment  = NSTextAlignmentLeft;
    [self addSubview:self.numberValueLable];
    
    self.unitLabel = [UILabel new];
    self.unitLabel.backgroundColor = [UIColor clearColor];
    self.unitLabel.textColor = [UIColor whiteColor];
    self.unitLabel.font  = [UIFont systemFontOfSize:14];
    self.unitLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.unitLabel];

    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(14);
        make.bottom.equalTo(self.valueLable.mas_top).mas_offset(-14);
        make.centerX.equalTo(self.mas_centerX).mas_offset(0);
    }];
    
    [_unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(20);
        make.bottom.equalTo(_titleLabel.mas_bottom).mas_offset(0);
        make.left.equalTo(_titleLabel.mas_right).mas_offset(5);
        make.width.equalTo(@50);
    }];
    
    [_valueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).mas_offset(14);
        make.bottom.equalTo(_numberTitleLabel.mas_top).mas_offset(-5);
        make.left.equalTo(self.mas_left).mas_offset(5);
        make.right.equalTo(self.mas_right).mas_offset(-5);
        make.height.equalTo(@53);
    }];
    
    [_numberValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_valueLable.mas_bottom).mas_offset(5);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-25);
        make.left.equalTo(self.numberTitleLabel.mas_right).mas_offset(10);
        make.right.equalTo(self.mas_right).mas_offset(-20);
    }];
    
    [_numberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberValueLable.mas_top).mas_offset(0);
        make.bottom.equalTo(self.numberValueLable.mas_bottom).mas_offset(0);
        make.left.equalTo(self.mas_left).mas_offset(5);
        make.right.equalTo(self.mas_centerX).mas_offset(20);
    }];
    
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    
  /*  CGFloat titleLabelW = self.sd_width;
    CGFloat titleLabelH = _titleLabelHeight;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.sd_height - titleLabelH;
    _titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    _titleLabel.hidden = !_titleLabel.text;*/
}

@end
