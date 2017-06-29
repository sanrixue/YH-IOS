//
//  MineInfoTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineInfoTableViewCell.h"

@implementation MineInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.septopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    self.septopView.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"];
    [self addSubview:self.septopView];
    
    self.sepbottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, SCREEN_WIDTH, 0.5)];
    self.sepbottomView.backgroundColor = [UIColor colorWithHexString:@"#bdbdbd"];
    //[self addSubview:self.sepbottomView];
    self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
   // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
