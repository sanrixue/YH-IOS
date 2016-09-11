//
//  GestureTableViewCell.h
//  YH-IOS
//
//  Created by li hao on 16/9/2.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mSCREEN [[UIScreen mainScreen]bounds]
#define mWIDTH  mSCREEN.size.width
 
@interface GestureTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) UISwitch *changStatusBtn;
@property (nonatomic,strong) UIButton *changeGestureBtn;
@property (nonatomic,strong) UIButton *changePasswordBtn;
@end
