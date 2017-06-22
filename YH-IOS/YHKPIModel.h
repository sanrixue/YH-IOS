//
//  YHKPIModel.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/22.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>


typedef NS_ENUM(NSUInteger, DashBoardType1) {
    DashBoardTypeBar1        = 1,
    DashBoardTypeLine1      = 2,
    DashBoardTypeRing1       = 3,
    DashBoardTypeNumber1     = 4,
    DashBoardTypeSignleValue1 = 5,
    DashBoardTypeSignleLongValue1 = 6,
    DashBoardTypeNumer11 = 7,
};

@class YHKPIDetailModel;
@class YHKPIDetailDataModel;

@interface YHKPIModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong)NSString *group_name;
@property (nonatomic,strong)NSArray<YHKPIDetailModel*>* data;

@end


@interface YHKPIDetailModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, assign, readonly) DashBoardType1 dashboardType; // 图形类型
@property (nonatomic, strong, readonly) NSString *unit; // 显示单位
@property (nonatomic, strong, readonly) NSString *title; // 标题
@property (nonatomic, strong, readonly) NSString *targeturl;
@property (nonatomic, strong, readonly) NSString *groupName; // 所属组
@property (nonatomic, assign, readonly) BOOL stick; // 置顶

@property (nonatomic, strong, readonly) NSString *memo1; // 所属组
@property (nonatomic, strong, readonly) NSString *memo2; // 所属组

@property (nonatomic, strong, readonly) NSArray *chartData; // 图标数据
@property (nonatomic, strong, readonly) YHKPIDetailDataModel *hightLightData; // 高亮数据
// 下三项为高亮数据中附属的值
@property (nonatomic, strong, readonly) NSString *floatRate; // 浮动率
@property (nonatomic, strong, readonly) NSString *saleNumber; // 销售金额
@property (nonatomic, assign, readonly) BOOL percentage; // 销售金额

-(UIColor *)getMainColor;

@end

@interface YHKPIDetailDataModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,assign)BOOL percentage;
@property(nonatomic,copy)NSString* number;
@property(nonatomic,copy)NSString* compare;
@property(nonatomic,assign)int arrow;

@end
