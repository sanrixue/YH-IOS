//
//  MineInfoTableViewCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *noticeImage;
@property (weak, nonatomic) IBOutlet UIImageView *noticeIcon;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
@property (weak, nonatomic) IBOutlet UILabel *userDetailLable;
@property (strong, nonatomic) UIView *septopView;
@property (strong, nonatomic) UIView *sepbottomView;

@end
