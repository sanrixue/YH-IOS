//
//  JYHistogram.h
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

/**
 * 柱状图中柱形宽度高度均动态根据数据变化
 * 高度随最大值变化
 * 宽度随数据元素的个数变化
 */
@interface JYHistogram : JYBaseComponentView <JYBaseComponentViewProtocal>

@property (nonatomic, copy) NSArray<NSNumber *> *dataSource;

@property (nonatomic, strong) UIColor *lastBarColor;
@property (nonatomic, strong) UIColor *barColor;// 不包含最后一条
@property (nonatomic, strong) NSString *lineCap; // eg.kCALineCapRound


@end
