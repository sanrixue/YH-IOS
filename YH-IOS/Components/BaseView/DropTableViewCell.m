//
//  DropTableViewCell.m
//  YH-IOS
//
//  Created by li hao on 16/8/17.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "DropTableViewCell.h"

@implementation DropTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initWithSubview];
    }
    return self;
}

#pragma mark 初始化视图
- (void)initWithSubview {
    self.iconImageView = [[UIImageView alloc]init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.tittleLabel = [[UILabel alloc]init];
    [self.tittleLabel setTextColor:[UIColor whiteColor]];
    self.tittleLabel.font = [UIFont systemFontOfSize:14];
    self.tittleLabel.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.tittleLabel];
    self.backgroundColor = [UIColor clearColor];
    [self layoutView];
}

- (void)layoutView {
    for (UIView *view in [self.contentView subviews]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(self.contentView,_iconImageView,_tittleLabel);
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_iconImageView(20)]-20-[_tittleLabel]-2-|" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_iconImageView]-10-|" options:0 metrics:nil views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_tittleLabel]-3-|" options:0 metrics:nil views:viewDict]];
}



@end
