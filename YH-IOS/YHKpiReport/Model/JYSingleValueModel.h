//
//  JYSingleValueModel.h
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

@interface JYSingleValueModel : JYModuleTwoBaseModel

@property (nonatomic, strong, readonly) UIColor *stateColor;
@property (nonatomic, strong, readonly) NSString *mainName;
@property (nonatomic, strong, readonly) NSString *subName;
@property (nonatomic, strong, readonly) NSString *mainData; // 主数值
@property (nonatomic, strong, readonly) NSString *subData; // 对比数值
@property (nonatomic, strong, readonly) NSString *floatRatio;


@end
