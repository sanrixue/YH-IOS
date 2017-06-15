//
//  SingleLabelTableViewCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/10.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "SingleLabelTableViewCell.h"

@implementation SingleLabelTableViewCell

-(instancetype)init{
    self= [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setupUI{
    self.contentLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, self.frame.size.height - 10)];
    [self addSubview:_contentLable];
    self.contentLable.layer.cornerRadius = 5;
    self.contentLable.textAlignment = NSTextAlignmentCenter;
    self.contentLable.backgroundColor = [UIColor colorWithHexString:@"#6aa657"];
    self.contentLable.textColor = [UIColor whiteColor];
    self.contentLable.clipsToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
