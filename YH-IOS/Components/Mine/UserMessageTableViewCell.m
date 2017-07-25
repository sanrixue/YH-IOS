//
//  UserMessageTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "UserMessageTableViewCell.h"

@implementation UserMessageTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
    
}

-(void)layoutViews {
    // 累计登录次数
    self.loginCountView = [[UserCountView alloc]init];
    self.loginCountView.utilLabel.text =@"天";
    self.loginCountView.dataLable.text = @"0";
    self.loginCountView.noteLabel.text = @"累计登录";
    self.loginCountView.dataLable.textColor = [UIColor colorWithHexString:@"#00a4e9"];
    self.loginCountView.utilLabel.textColor = [UIColor colorWithHexString:@"#00a4e9"];
    [self addSubview:self.loginCountView];
    
    //浏览报表次数
    self.reportScanCountView = [[UserCountView alloc]init];
    self.reportScanCountView.utilLabel.text = @"支";
    self.reportScanCountView.dataLable.text = @"0";
    self.reportScanCountView.dataLable.textColor = [UIColor colorWithHexString:@"#91c941"];
    self.reportScanCountView.utilLabel.textColor = [UIColor colorWithHexString:@"#91c941"];
    self.reportScanCountView.noteLabel.text = @"浏览报表";
    [self addSubview:self.reportScanCountView];
    
    // 超越用户
    self.precentView = [[UserCountView alloc]init];
    self.precentView.utilLabel.text = @"%";
    self.precentView.dataLable.text = @"0";
    self.precentView.noteLabel.text = @"超越用户";
    self.precentView.dataLable.textColor = [UIColor colorWithHexString:@"#f57658"];
    self.precentView.utilLabel.textColor = [UIColor colorWithHexString:@"#f57658"];
    [self addSubview:self.precentView];
    [self layoutUI];
}

-(void)layoutUI {
    
    [self.loginCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(40);
        make.right.equalTo(self.reportScanCountView.mas_left).mas_offset(-20);
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-16);
    }];
    [self.reportScanCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-16);
        make.centerX.equalTo(self.mas_centerX).mas_offset(0);
    }];
    [self.precentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-16);
        make.right.mas_equalTo(self.mas_right).mas_offset(-40);
        make.left.mas_equalTo(self.reportScanCountView.mas_right).mas_offset(20);
        make.width.equalTo(@[self.reportScanCountView.mas_width,self.loginCountView.mas_width]);
    }];

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshViewWith:(NSDictionary *)person {
    
    // [self.avaterImageView sd_setImageWithURL:person.icon forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_ava"]];
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
}

@end
