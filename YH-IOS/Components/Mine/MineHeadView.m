//
//  MineHeadView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineHeadView.h"

@implementation MineHeadView


-(instancetype)initWithFrame:(CGRect)frame withPerson:(Person*)person{
    self = [super initWithFrame:frame];
    if (self) {
        self.person = person;
    }
    return self;
}

-(void)layoutSubviews{
    [self setLayout];
}


-(void)setLayout {
    
    //用户头像
    self.avaterImageView = [[UIImageView alloc]init];
    //_avaterImageView.layer.cornerRadius = 44;
    self.avaterImageView.image = [UIImage imageNamed:@"user_ava"];
    [self addSubview:_avaterImageView];
    
    // 用户名
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.font = [UIFont systemFontOfSize:16];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.text = @" 张雪迎";
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"#000"];
    [self addSubview:self.userNameLabel];

    
    // 上次登录状态
    self.lastLoginMessageLabel = [[UILabel alloc]init];
    self.lastLoginMessageLabel.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    self.lastLoginMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.lastLoginMessageLabel.font = [UIFont systemFontOfSize:9];
    [self addSubview:self.lastLoginMessageLabel];
    self.lastLoginMessageLabel.text = @"最近一次: 福州    2017/06/05/11:47";
    
    // 累计登录次数
    self.loginCountView = [[UIView alloc]init];
    self.loginCountView.backgroundColor = [UIColor redColor];
    [self addSubview:self.loginCountView];
    
    //浏览报表次数
    self.reportScanCountView = [[UIView alloc]init];
    self.reportScanCountView.backgroundColor = [UIColor redColor];
    [self addSubview:self.reportScanCountView];
    
    // 超越用户
    self.precentView = [[UIView alloc]init];
    self.precentView.backgroundColor = [UIColor redColor];
    [self addSubview:self.precentView];
    
    
    [self layoutUI];
}


-(void)layoutUI {
    
    [self.avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top).mas_offset(55+15);
        make.left.mas_equalTo(self.left).mas_offset(SCREEN_WIDTH/2-44);
        make.height.mas_equalTo(88);
        make.right.mas_equalTo(self.right).mas_offset(- (SCREEN_WIDTH/2-44));
    }];
   
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        NSLog(@"图片的底部是:--%f ",self.avaterImageView.bottom);
        NSLog(@"图片高是 -- %f",self.avaterImageView.width);
        make.top.mas_equalTo(self.top).mas_offset(173);
        make.left.mas_equalTo(self.left).mas_offset(10);
        make.height.mas_equalTo(20);
       // make.bottom.mas_greaterThanOrEqualTo(self.bottom).mas_offset(-10);
        make.right.mas_equalTo(self.right).mas_offset(-10);
    }];
    
    [self.lastLoginMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top).mas_offset(200);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(12);
    }];
    
    [self.loginCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.top).mas_offset(224);
        make.left.mas_equalTo(self.left).mas_offset(40);
        make.bottom.mas_equalTo(self.bottom).mas_equalTo(-14.5);
        make.width.mas_equalTo(self.reportScanCountView.width);
        make.right.mas_equalTo(self.reportScanCountView.left).mas_offset(56);
        make.width.mas_equalTo(self.precentView.width);
    }];
    
}


-(void)refreshViewWith:(Person *)person {
    [self.avaterImageView sd_setImageWithURL:person.icon];
    self.userNameLabel.text = @"美丽美丽";
}

@end
