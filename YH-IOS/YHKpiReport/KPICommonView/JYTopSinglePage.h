//
//  JYTopSinglePage.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYDashboardModel.h"

#define kJYPageHeight 218

@interface JYTopSinglePage : UIView

@property (nonatomic, copy) JYDashboardModel *model;

- (void)refreshSubViewData;

@end
