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
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, 120, self.frame.size.height - 20)];
    
    [self.contentView addSubview:self.messageLabel];
    

    self.messageLabel .textColor=[UIColor colorWithHexString:@"#666666"];
    self.messageLabel .font=[UIFont systemFontOfSize:15];
    [self.messageLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(17);
        make.left.mas_equalTo(self.contentView.mas_left).offset(20);
    }];
    
    
  //  self.changStatusBtn = [[UISwitch alloc] initWithFrame:CGRectMake(mWIDTH -68, 13, 48, 24)];
    
    self.changStatusBtn = [[UISwitch alloc] init];
    
    [self.changStatusBtn addTarget:self action:@selector(UISwitchValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.changStatusBtn setOnTintColor:[UIColor colorWithHexString:@"#00a4e9"]];
    
    
    [self addSubview:self.changStatusBtn];
    
    [self.changStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_right).offset(-20);
        
        make.top.mas_equalTo(self.mas_top).offset(12);
        
        make.size.mas_equalTo(CGSizeMake(48, 24));
    }];
    
    
    
    
    
    
}

- (void)UISwitchValueChange:(UISwitch *)changeStatueButton {
    [_delegate SwitchTableViewCellButtonClick:changeStatueButton with:self.cellId];
}
@end
