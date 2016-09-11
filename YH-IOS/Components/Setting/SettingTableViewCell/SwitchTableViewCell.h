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
@interface SwitchTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UISwitch *changStatusBtn;
@end
