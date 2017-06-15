//
//  MineRequestListCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/13.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineRequestListCell.h"

@implementation MineRequestListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noteView.layer.cornerRadius = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#000"];
    
    
    self.contentLable.textColor = [UIColor colorWithHexString:@"#6e6e6e"];
    self.contentLable.font = [UIFont systemFontOfSize:12];
    // Initialization code
    self.noteView.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
