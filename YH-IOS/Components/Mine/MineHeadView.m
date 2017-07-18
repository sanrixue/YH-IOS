//
//  MineHeadView.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineHeadView.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface MineHeadView()

@property(nonatomic, strong)User *user;

@end

@implementation MineHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _user = [[User alloc]init];
        [self stupUI];
    }
    return self;
}

-(void)stupUI{
    [self setLayout];
}


-(void)setLayout {
    
    //用户头像
    self.avaterImageView = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-44, 40, 88, 88)];
    [self.avaterImageView addTarget:self action:@selector(ClickAvaIamge:) forControlEvents:UIControlEventTouchUpInside];
    self.avaterImageView.layer.cornerRadius =44;
   // [self.avaterImageView setImage:[UIImage imageNamed:@"user_ava"] forState:UIControlStateNormal];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:_user.gravatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_ava"]];
    //_avaterImageView.layer.cornerRadius = 44;
    [self addSubview:_avaterImageView];
    [self.avaterImageView.layer setMasksToBounds:YES];
    
    // 用户名
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.font = [UIFont systemFontOfSize:16];
    self.userNameLabel.textAlignment = NSTextAlignmentCenter;
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"#000"];
    [self addSubview:self.userNameLabel];

    
    // 上次登录状态
    self.lastLoginMessageLabel = [[UILabel alloc]init];
    self.lastLoginMessageLabel.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    self.lastLoginMessageLabel.text =@"暂无上次登录数据";
    self.lastLoginMessageLabel.textAlignment = NSTextAlignmentCenter;
    self.lastLoginMessageLabel.font = [UIFont systemFontOfSize:9];
    [self addSubview:self.lastLoginMessageLabel];
    
    // 累计登录次数
    self.loginCountView = [[UserCountView alloc]init];
    self.loginCountView.utilLabel.text =@"天";
    self.loginCountView.dataLable.text = @"0";
    self.loginCountView.noteLabel.text = @"累计登录";
   // self.loginCountView.frame = CGRectMake(40, 224, 80, 80);
    [self addSubview:self.loginCountView];
    
    //浏览报表次数
    self.reportScanCountView = [[UserCountView alloc]init];
    self.reportScanCountView.utilLabel.text = @"支";
    self.reportScanCountView.dataLable.text = @"0";
    self.reportScanCountView.noteLabel.text = @"浏览报表";
    [self addSubview:self.reportScanCountView];
    
    // 超越用户
    self.precentView = [[UserCountView alloc]init];
    self.precentView.utilLabel.text = @"%";
    self.precentView.dataLable.text = @"0";
    self.precentView.noteLabel.text = @"超越用户";
    [self addSubview:self.precentView];
    
    [self layoutUI];
    
}


-(void)layoutUI {
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        NSLog(@"图片的底部是:--%f ",self.avaterImageView.bottom);
        NSLog(@"图片高是 -- %f",self.avaterImageView.width);
        make.top.mas_equalTo(self.mas_top).mas_offset(143);
        make.left.mas_equalTo(self.mas_left).mas_offset(10);
        make.height.mas_equalTo(20);
       // make.bottom.mas_greaterThanOrEqualTo(self.bottom).mas_offset(-10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
    
    [self.lastLoginMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).mas_offset(10);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(12);
    }];
    
    [self.loginCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lastLoginMessageLabel.mas_bottom).mas_offset(17.5);
        make.left.mas_equalTo(self.mas_left).mas_offset(20);
        make.bottom.mas_equalTo(self.mas_bottom).mas_equalTo(-14.5);
       // make.width.mas_equalTo(self.reportScanCountView.width);
        make.right.equalTo(self.reportScanCountView.mas_left).mas_offset(-20);
       // make.width.mas_equalTo(self.precentView.width);
    }];
    [self.reportScanCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginCountView.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-14.5);
        make.centerX.equalTo(self.mas_centerX).mas_offset(0);
        //make.right.mas_equalTo(self.precentView.left).mas_offset(56);
    }];
    [self.precentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginCountView.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-14.5);
        make.right.mas_equalTo(self.mas_right).mas_offset(-40);
        make.left.mas_equalTo(self.reportScanCountView.mas_right).mas_offset(20);
        make.width.equalTo(@[self.reportScanCountView.mas_width,self.loginCountView.mas_width]);
    }];
    
}


-(void)ClickAvaIamge:(UIButton *)btn{
    [self.delegate ClickButton:btn];
}


-(void)refreshViewWith:(NSDictionary *)person {
   
   // [self.avaterImageView sd_setImageWithURL:person.icon forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_ava"]];
    self.userNameLabel.text = _user.userName;
    if ([person[@"login_duration"] isEqualToString:@""] || person[@"login_duration"] == nil) {
        self.loginCountView.dataLable.text = @"0";
    }
    else{
        self.loginCountView.dataLable.text = [NSString stringWithFormat:@"%@",person[@"login_duration"]];
    }
    self.loginCountView.utilLabel.text = @"天";
    self.loginCountView.noteLabel.text = @"累计登录";
   // NSString *lastLoginState = [NSString stringWithFormat:@"最近一次: %@   %@",person.lastlocation,person.time];
  //  self.lastLoginMessageLabel.text = lastLoginState;
    if ([person[@"browse_report_count"] isEqualToString:@""] || person[@"browse_report_count"] == nil) {
            self.reportScanCountView.dataLable.text = @"0";
    }
    else {
            self.reportScanCountView.dataLable.text =[NSString stringWithFormat:@"%@", person[@"browse_report_count"]];
    }
    self.reportScanCountView.utilLabel.text = @"支";
    self.reportScanCountView.noteLabel.text = @"浏览报表";
    if (person[@"surpass_percentage"] == nil ) {
            self.precentView.dataLable.text = [NSString stringWithFormat:@"%.1f",[@"0.0" floatValue]];
    }
    else{
        self.precentView.dataLable.text = [NSString stringWithFormat:@"%.1f",[person[@"surpass_percentage"] floatValue]];
         }
    self.precentView.utilLabel.text = @"%";
    self.precentView.noteLabel.text = @"超越用户";
    if ([person[@"coordinate_location"] isEqualToString:@""] || person[@"coordinate_location"] == nil) {
            self.lastLoginMessageLabel.text = [NSString stringWithFormat:@"上次登录:%@",@"暂无上次登录信息"];
    }
    else{
      self.lastLoginMessageLabel.text = [NSString stringWithFormat:@"上次登录:%@",person[@"coordinate_location"]];
         }
}


-(void)refeshAvaImgeView:(UIImage *)image{
    [self.avaterImageView setImage:image forState:UIControlStateNormal];
}
@end
