//
//  UserHeadView.h
//  YH-IOS
//
//  Created by li hao on 16/9/2.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mSCREEN [[UIScreen mainScreen]bounds]
#define mWIDTH  mSCREEN.size.width

@interface UserHeadView : UITableViewCell
@property (strong, nonatomic)UIButton *userIcon;
@property (strong, nonatomic)UILabel *userName;
@property (strong, nonatomic)UILabel *userRole;
@end
