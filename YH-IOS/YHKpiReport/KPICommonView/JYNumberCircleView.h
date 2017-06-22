//
//  JYNumberCircleView.h
//  各种报表
//
//  Created by niko on 17/4/29.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYDashboardModel.h"
#import "YHKPIModel.h"

/* 带销售值的环形图 */
@interface JYNumberCircleView : UIView

@property (nonatomic, copy) YHKPIDetailModel *model;

@end
