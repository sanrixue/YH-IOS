//
//  RightSwitchTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "RightSwitchTableViewCell.h"

@implementation RightSwitchTableViewCell

-(id)initWith:(BOOL)isclick {
    self = [super init];
    if (self) {
        self.isClick = isclick;
        [self initSubView];
    }
    return self;
}


-(void)initSubView {
    // 标题
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titleLabel];
    
    // 切换按钮
    self.SwitchButton = [[UIButton alloc]init];
    [self.SwitchButton addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventTouchUpInside];
    if (!_isClick) {
        [self.SwitchButton setImage:[UIImage imageNamed:@"btn_open.png"] forState:UIControlStateNormal];
    }
    else{
        [self.SwitchButton setImage:[UIImage imageNamed:@"btn_open_pre.png"] forState:UIControlStateNormal];
    }
    [self.contentView addSubview:self.SwitchButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(10);
        make.left.equalTo(self.mas_left).mas_offset(25);
        make.right.equalTo(self.SwitchButton.mas_left).mas_offset(40);
        make.bottom.equalTo(self.SwitchButton.mas_bottom).mas_offset(-5);
    }];
    
    [self.SwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).mas_offset(0);
        make.right.equalTo(self.mas_right).mas_offset(-26);
        make.bottom.equalTo(self.titleLabel.mas_bottom).mas_offset(-4);
    }];
    
}

-(void)switchClick:(UIButton *)sender {
    _isClick = !_isClick;
    if (!_isClick) {
        [self.SwitchButton setImage:[UIImage imageNamed:@"btn_open.png"] forState:UIControlStateNormal];
    }
    else{
        [self.SwitchButton setImage:[UIImage imageNamed:@"btn_open_pre.png"] forState:UIControlStateNormal];
    }
    [_delegate SwitchTableViewCellButtonClick:sender with:_cellId withIsClick:_isClick];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
