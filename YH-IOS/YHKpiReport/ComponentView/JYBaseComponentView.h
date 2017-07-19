//
//  JYBaseComponentView.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYDashboardModel.h"


@protocol JYBaseComponentViewProtocal <NSObject>

@required
/* 刷新数据 */
- (void)refreshSubViewData;

@end

@interface JYBaseComponentView : UIView <JYBaseComponentViewProtocal>

/* 默认无，当设置时，自动实现动画效果 */
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) JYBaseModel *model;

- (CGFloat)estimateViewHeight:(JYBaseModel *)model;

@end
