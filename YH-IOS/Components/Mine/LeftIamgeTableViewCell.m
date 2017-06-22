//
//  LeftIamgeTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "LeftIamgeTableViewCell.h"

@implementation LeftIamgeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _contentIamge = [[UIImageView alloc]initWithFrame:CGRectMake(13, 9, 14, 16)];
    [_leftImage addSubview:_contentIamge];
    [_rightText setSecureTextEntry:YES];
    
   // _rightText.layer.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"].CGColor;
    //_rightText.layer.borderColor = [UIColor colorWithHexString:@"#aaa"].CGColor;
    self.layer.cornerRadius = 5;
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
