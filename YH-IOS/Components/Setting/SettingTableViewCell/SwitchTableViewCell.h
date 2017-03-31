//
//  SwitchTableViewCell.h
//  YH-IOS
//
//  Created by APPLE on 16/8/31.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mSCREEN [[UIScreen mainScreen]bounds]
#define mWIDTH  mSCREEN.size.width
@protocol SwitchTableViewCellDelegate

-(void)SwitchTableViewCellButtonClick:(UISwitch *)button with:(NSInteger)cellId;

@end

@interface SwitchTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UISwitch *changStatusBtn;
@property (nonatomic,assign) NSInteger cellId;
@property (nonatomic,weak) id<SwitchTableViewCellDelegate> delegate;
@end
