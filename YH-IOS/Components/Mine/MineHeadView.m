//
//  MineHeadView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineHeadView.h"

@implementation MineHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
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
    [self addSubview:_avaterImageView];
    
    // 用户名
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.font = [UIFont systemFontOfSize:16];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.text = @" 张雪迎";
    self.userNameLabel.backgroundColor = [UIColor greenColor];
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"#000"];
    [self addSubview:self.userNameLabel];

    
    // 上次登录状态
    
    self.lastLoginMessageLabel = [[UILabel alloc]init];
    self.lastLoginMessageLabel.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    self.lastLoginMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.lastLoginMessageLabel.font = [UIFont systemFontOfSize:9];
    [self addSubview:self.lastLoginMessageLabel];
    
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
    
}


-(void)refreshViewWith:(Person *)person {
    [self.avaterImageView sd_setImageWithURL:person.icon];
    self.userNameLabel.text = @"美丽美丽";
}

@end
