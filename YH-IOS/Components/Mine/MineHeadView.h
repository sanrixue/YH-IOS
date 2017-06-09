//
//  MineHeadView.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/8.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

@interface MineHeadView : UIView

@property (nonatomic, strong)UIImageView *avaterImageView;
@property (nonatomic, strong)UILabel *userNameLabel;
@property (nonatomic, strong)UILabel *lastLoginMessageLabel;
@property (nonatomic, strong)UILabel *loginCountLabel;
@property (nonatomic, strong)UILabel *reportScanCountLabel;
@property (nonatomic, strong)UILabel *precentLable;

// 刷新视图

-(void)refreshViewWith:(Person *)person;
@end
