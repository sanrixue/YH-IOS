//
//  RightButtonTableViewCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/9.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightButtonTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *verifyText;
@property (weak, nonatomic) IBOutlet UIButton *getVerifyCode;

@end
