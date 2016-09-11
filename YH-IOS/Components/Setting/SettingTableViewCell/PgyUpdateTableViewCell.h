//
//  PgyUpdateTableViewCell.h
//  YH-IOS
//
//  Created by li hao on 16/9/1.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

#define mSCREEN [[UIScreen mainScreen]bounds]
#define mWIDTH  mSCREEN.size.width
@interface PgyUpdateTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *messageButton;
@property (nonatomic,strong) UIButton *openOutLink;
@property (nonatomic,strong) UILabel *outLinkLabel;
@end
