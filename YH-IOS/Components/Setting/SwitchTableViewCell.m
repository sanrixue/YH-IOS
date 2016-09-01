//
//  SwitchTableViewCell.m
//  YH-IOS
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "SwitchTableViewCell.h"

@implementation SwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initWithSubview {
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 10,120 , self.frame.size.height - 20)];
    [self.contentView addSubview:self.messageLabel];
    self.changStatusBtn = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 10, 60, self.frame.size.height - 20)];
    [self.contentView addSubview:self.changStatusBtn];
}

@end
