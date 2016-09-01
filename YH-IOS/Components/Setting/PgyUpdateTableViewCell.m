//
//  PgyUpdateTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/9/1.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "PgyUpdateTableViewCell.h"

@implementation PgyUpdateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initWithSubview {
    self.messageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10,100 , self.frame.size.height - 20)];
    [self.messageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.messageButton];
    self.openOutLink = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.messageButton.frame) + 10, 10, self.frame.size.width - 110, self.frame.size.height -20)];
    [self.openOutLink setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.openOutLink.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.openOutLink];
}

@end
