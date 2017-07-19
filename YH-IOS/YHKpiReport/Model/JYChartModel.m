//
//  JYChartModel.m
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYChartModel.h"

@implementation JYChartModel

- (JYSeriesModel *)seriesModel {
    JYSeriesModel *obj = [JYSeriesModel modelWithParams:[self.configInfo objectForKey:@"series"]];
    return obj;
}

- (NSArray<NSString *> *)legend {
    return self.configInfo[@"legend"];
}

- (NSArray<NSString *> *)xAxis {
    return self.configInfo[@"xAxis"];
}


@end
