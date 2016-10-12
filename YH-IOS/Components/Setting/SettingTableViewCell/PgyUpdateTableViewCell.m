//
//  PgyUpdateTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/9/1.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "PgyUpdateTableViewCell.h"
#import "Constant.h"
#import "UIColor+Hex.h"

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
    UIColor *linkColor = [UIColor colorWithHexString:kThemeColor];
    self.messageButton = [[UIButton alloc] initWithFrame:CGRectMake(18, 10,110, self.frame.size.height - 20)];
    [self.messageButton setTitleColor:linkColor forState:UIControlStateNormal];
    self.messageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.messageButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.messageButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.messageButton];
    
    self.openOutLink = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.messageButton.frame) + 80, 10, mWIDTH - 220, self.frame.size.height - 20)];
    [self.openOutLink setTitleColor:linkColor forState:UIControlStateNormal];
    self.openOutLink.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.openOutLink.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.openOutLink.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.openOutLink];
}

@end
