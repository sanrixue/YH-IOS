//
//  CustomCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCellDelegate <NSObject>

-(void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId;

@end


@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UISwitch *SwitchButton;

@property (weak, nonatomic) id<CustomCellDelegate> delegate;
@property (nonatomic,assign) NSInteger cellId;

@end
