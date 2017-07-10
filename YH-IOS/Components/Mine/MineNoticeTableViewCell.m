//
//  MineNoticeTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineNoticeTableViewCell.h"

@implementation MineNoticeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noteView.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    
    self.noteView.layer.cornerRadius =3;
    
    self.timeLable.font = [UIFont boldSystemFontOfSize:12];
    
    self.timeLable.textColor = [UIColor colorWithHexString:@"#bfbfbf"];
    self.contentLable.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
