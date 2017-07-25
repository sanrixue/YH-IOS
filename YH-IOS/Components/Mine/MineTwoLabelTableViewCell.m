//
//  MineTwoLabelTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "MineTwoLabelTableViewCell.h"

@implementation MineTwoLabelTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutViews];
    }
    return self;
}

-(void)layoutViews {
    
    //左侧图片
    self.leftImageView = [[UIImageView alloc]init];
    [self addSubview:self.leftImageView];
    
    //左侧 label
    self.leftLabel = [[UILabel alloc]init];
    [self addSubview:_leftLabel];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    //右侧 label
    self.rightLabel = [[UILabel alloc]init];
    [self addSubview:_rightLabel];
    self.rightLabel.font = [UIFont systemFontOfSize:16];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#32414b"];
    
    [self layoutUI];
    
}

-(void)layoutUI {
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.leftLabel.mas_left).mas_offset(-10);
        make.top.mas_equalTo(self.mas_top).mas_offset(17);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-17);
        make.height.mas_equalTo(@16);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.mas_top).mas_offset(17);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-17);
        make.height.mas_equalTo(@16);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-20);
        make.top.mas_equalTo(self.mas_top).mas_offset(16);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-16);
        make.height.mas_equalTo(@18);
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
