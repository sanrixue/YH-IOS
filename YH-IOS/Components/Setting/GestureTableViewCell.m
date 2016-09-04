//
//  GestureTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/9/2.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "GestureTableViewCell.h"

@implementation GestureTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initWithSubview {
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 5, 120 , self.frame.size.height / 2)];
    [self.contentView addSubview:self.messageLabel];
    self.changStatusBtn = [[UISwitch alloc] initWithFrame:CGRectMake(mWIDTH - 70, 5, 50, self.frame.size.height / 2)];
    [self.contentView addSubview:self.changStatusBtn];
    
    self.changeGestureBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, self.frame.size.height / 2 + 20, 100, self.frame.size.height / 2 - 10)];
    self.changeGestureBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.changeGestureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.changeGestureBtn];
}

@end
