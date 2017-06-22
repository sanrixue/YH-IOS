//
//  YHReportLeftTextTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/19.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "YHReportLeftTextTableViewCell.h"

@implementation YHReportLeftTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topsepLine.backgroundColor = [UIColor whiteColor];
    self.bottomSepLine.backgroundColor = [UIColor whiteColor];
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.bottomSepLine.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    //  self.selectedBackgroundView.backgroundColor = [UIColor clearColor];// 设置选中cell的背景view背景色
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.bottomSepLine.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    self.backgroundColor = [UIColor whiteColor];
   // self.bottomSepLine.backgroundColor = [UIColor colorWithHexString:@"#dedede"];
    // Configure the view for the selected state
}

@end
