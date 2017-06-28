//
//  RightSwitchTableViewCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/28.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol RightSwitchCellDelegate <NSObject>

-(void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId;

@end


@interface RightSwitchTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *label1;

@property (strong, nonatomic) UISwitch *SwitchButton;

@property (weak, nonatomic) id<RightSwitchCellDelegate> delegate;
@property (nonatomic,assign) NSInteger cellId;

@end
