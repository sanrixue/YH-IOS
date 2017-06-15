//
//  RightButtonTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "RightButtonTableViewCell.h"

@implementation RightButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _getVerifyCode.layer.cornerRadius = 5;
    _getVerifyCode.backgroundColor = [UIColor colorWithHexString:@"6aa657"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
