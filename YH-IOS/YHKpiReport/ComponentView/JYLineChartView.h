//
//  JYLineChartView.h
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

/**
 * 折线图，非光滑
 */
@interface JYLineChartView : JYBaseComponentView <JYBaseComponentViewProtocal>

@property (nonatomic, copy) NSArray<NSNumber *> *dataSource;

@property (nonatomic, strong) UIColor *lineColor;

@end
