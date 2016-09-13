//
//  ThurSayTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/9/11.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#define mSCREEN [[UIScreen mainScreen]bounds]
#import "ThurSayTableViewCell.h"

@implementation ThurSayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initWithSubview {
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 100, self.frame.size.height)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    
    self.grayArrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width- 60, 0, 40 ,self.frame.size.height)];
    self.grayArrow.image = [UIImage imageNamed:@"info-arrow"];
    [self addSubview:self.grayArrow];
}
@end
