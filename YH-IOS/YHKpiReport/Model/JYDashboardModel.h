//
//  JYDashboardModel.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseModel.h"

typedef NS_ENUM(NSUInteger, DashBoardType) {
    DashBoardTypeBar        = 1,
    DashBoardTypeLine       = 2,
    DashBoardTypeRing       = 3,
    DashBoardTypeNumber     = 4,
};


@interface JYDashboardModel : JYBaseModel


@property (nonatomic, assign, readonly) DashBoardType dashboardType; // 图形类型
@property (nonatomic, strong, readonly) NSString *unit; // 显示单位
@property (nonatomic, strong, readonly) NSString *title; // 标题
@property (nonatomic, strong, readonly) NSString *targeturl;
@property (nonatomic, strong, readonly) NSString *groupName; // 所属组
@property (nonatomic, assign, readonly) BOOL stick; // 置顶

@property (nonatomic, strong, readonly) NSArray *chartData; // 图标数据
@property (nonatomic, strong, readonly) NSDictionary *hightLightData; // 高亮数据
// 下三项为高亮数据中附属的值
@property (nonatomic, strong, readonly) NSString *floatRate; // 浮动率
@property (nonatomic, strong, readonly) NSString *saleNumber; // 销售金额
@property (nonatomic, assign, readonly) BOOL percentage; // 单位是否显示为百分比号




@end
