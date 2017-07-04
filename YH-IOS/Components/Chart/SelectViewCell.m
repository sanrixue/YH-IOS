//
//  SelectViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/4.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SelectViewCell.h"

@implementation SelectViewCell

-(instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDeth:(int) depth{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.depth = depth;
        [self layoutView];
    }
    return self;
}



-(void)layoutView{
    
    self.clickImage = [[UIImageView alloc]init];
   //self.clickImage.image.renderingMode = UIImageRenderingModeAlwaysOriginal;
    [self.contentView addSubview:self.clickImage];
    
    self.contentLable = [[UILabel alloc]init];
    self.contentLable.font = [UIFont systemFontOfSize:14];
    self.contentLable.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.contentLable];
    
    [self.clickImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(10);
        make.left.equalTo(self.mas_left).mas_offset(10 + self.depth * 30);
        make.right.equalTo(self.contentLable.mas_left).mas_offset(-20 );
        make.bottom.equalTo(self.mas_bottom).mas_offset(-10);
    }];
    
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_offset(5);
        make.left.equalTo(self.clickImage.mas_right).mas_offset(20);
        make.bottom.equalTo(self.mas_bottom).mas_offset(-5);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
