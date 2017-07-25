//
//  UserCountView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "UserCountView.h"

@implementation UserCountView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    //数据
    _dataLable = [[UILabel alloc]init];
    _dataLable.font = [UIFont systemFontOfSize:40];
    _dataLable.textAlignment= NSTextAlignmentRight;
    _dataLable.text = @"0";
    [self addSubview:_dataLable];
    
    // 单位
    _utilLabel = [[UILabel alloc]init];
    _utilLabel.font = [UIFont systemFontOfSize:10];
    _utilLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_utilLabel];
    
    //名称
    _noteLabel = [[UILabel alloc]init];
    _noteLabel.font = [UIFont systemFontOfSize:11];
    _noteLabel.adjustsFontSizeToFitWidth = YES;
    _noteLabel.textColor = [UIColor colorWithHexString:@"#666"];
    _noteLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_noteLabel];
    
    
    [_dataLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(2);
        make.centerX.equalTo(self.mas_centerX).mas_offset(-5);
        make.right.equalTo(self.utilLabel.mas_left).mas_offset(-2);
        make.bottom.equalTo(self.noteLabel.mas_top).mas_offset(-3);
    }];
    
    [_utilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dataLable.mas_bottom).mas_offset(-4);
        make.width.equalTo(@13);
    }];
    
    [_noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dataLable.mas_bottom).mas_offset(3);
        make.centerX.equalTo(self.mas_centerX).mas_offset(0);
        make.bottom.equalTo(self.mas_bottom).mas_offset(0);
    }];
}


@end
