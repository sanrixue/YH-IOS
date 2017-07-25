//
//  UserAvaTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "UserAvaTableViewCell.h"
#import "User.h"

@interface UserAvaTableViewCell()

@property(nonatomic, strong)User *user;

@end

@implementation UserAvaTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _user = [[User alloc]init];
        [self layoutViews];
    }
    return  self;
}

-(void)layoutViews{
    //用户头像
    self.avaterImageView = [[UIButton alloc]initWithFrame:CGRectMake(adaptWidth(20.5), adaptHeight(20), 55, 55)];
    self.avaterImageView.layer.cornerRadius = 27.5;
    // [self.avaterImageView setImage:[UIImage imageNamed:@"user_ava"] forState:UIControlStateNormal];
    [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:_user.gravatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"user_ava"]];
    //_avaterImageView.layer.cornerRadius = 44;
    [self addSubview:_avaterImageView];
    [self.avaterImageView.layer setMasksToBounds:YES];
    
    // 用户名
    self.userNameLabel = [[UILabel alloc]init];
    self.userNameLabel.font = [UIFont boldSystemFontOfSize:17];
    self.userNameLabel.textAlignment = NSTextAlignmentLeft;
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"#32414b"];
    [self addSubview:self.userNameLabel];
    
    // 上次登录状态
    self.userRoleLabel = [[UILabel alloc]init];
    self.userRoleLabel.textColor = [UIColor colorWithHexString:@"#666"];
    self.userRoleLabel.text =@"暂无上次登录数据";
    self.userRoleLabel.textAlignment = NSTextAlignmentLeft;
    self.userRoleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.userRoleLabel];
    
    [self layoutUI];

}


-(void)layoutUI {
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        NSLog(@"图片的底部是:--%f ",self.avaterImageView.bottom);
        NSLog(@"图片高是 -- %f",self.avaterImageView.width);
        make.top.mas_equalTo(self.avaterImageView.mas_top).mas_offset(9.5);
        make.left.mas_equalTo(self.avaterImageView.mas_right).mas_offset(15.5);
        make.height.mas_equalTo(15.5);
        // make.bottom.mas_greaterThanOrEqualTo(self.bottom).mas_offset(-10);
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
    
    [self.userRoleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).mas_offset(11.5);
        make.left.right.mas_equalTo(self.userNameLabel);
        make.height.mas_equalTo(11.5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
