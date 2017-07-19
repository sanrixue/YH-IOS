//
//  JYModuleTwoBaseModel.h
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseModel.h"

typedef NS_ENUM(NSUInteger, JYDetailChartType) {
    JYDetailChartTypeBanner           = 0, // 顶部说明，轮播
    JYDetailChartTypeLine             = 1, // 线性折线图
    JYDetailChartTypeTables           = 2, // excel
    JYDetailChartTypeInfo             = 3, // 副标题说明
    JYDetailChartTypeSingleValue      = 4, // 单值对比图
    JYDetailChartTypeBargraph         = 5, // 横向条状图
    JYDetailChartTypeCartHistogram    = 6, // 柱状图
};


@interface JYModuleTwoBaseModel : JYBaseModel

@property (nonatomic, assign, readonly) JYDetailChartType chartType;
@property (nonatomic, strong, readonly) NSDictionary *configInfo;

+ (instancetype)moduleTwoBaseModelWithParams:(NSDictionary *)params;

@end
