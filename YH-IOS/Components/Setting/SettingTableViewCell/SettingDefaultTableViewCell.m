//
//  SettingDefaultTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/9/5.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "SettingDefaultTableViewCell.h"

@implementation SettingDefaultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initWithSubview {
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 100,self.frame.size.height)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.font = [UIFont systemFontOfSize:16];

    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 10, 0, [[UIScreen mainScreen]bounds].size.width -144 ,self.frame.size.height)];
    self.detailLabel.textColor = [UIColor grayColor];
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.adjustsFontSizeToFitWidth = YES;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.detailLabel];
}
@end
