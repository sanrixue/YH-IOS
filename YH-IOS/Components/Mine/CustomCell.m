//
//  CustomCell.m
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

-(id)init{
   self =  [super init];
    if (self) {
        self.SwitchButton.onImage = [[UIImage imageNamed:@"btn_open_pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.SwitchButton.offImage = [[UIImage imageNamed:@"btn_open_pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return self;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.SwitchButton.onImage = [[UIImage imageNamed:@"btn_open_pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.SwitchButton.offImage = [[UIImage imageNamed:@"btn_open_pre.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.SwitchButton.transform = CGAffineTransformMakeScale(0.75, 0.6);
    self.SwitchButton.onTintColor = [UIColor colorWithHexString:@"#a7d20f"];
    [self.SwitchButton addTarget:self action:@selector(UISwitchValueChange:) forControlEvents:UIControlEventValueChanged];
}


- (void)UISwitchValueChange:(UISwitch *)changeStatueButton {
    [_delegate SwitchTableViewCellButtonClick:changeStatueButton with:self.cellId];
}


@end
