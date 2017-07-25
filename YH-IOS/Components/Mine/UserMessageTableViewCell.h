//
//  UserMessageTableViewCell.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/7/24.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCountView.h"

@interface UserMessageTableViewCell : UITableViewCell

@property (nonatomic, strong)UserCountView *loginCountView;
@property (nonatomic, strong)UserCountView *reportScanCountView;
@property (nonatomic, strong)UserCountView *precentView;

-(void)refreshViewWith:(NSDictionary *)person;

@end
