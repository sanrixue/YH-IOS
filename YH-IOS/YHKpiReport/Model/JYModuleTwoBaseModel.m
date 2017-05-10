//
//  JYModuleTwoBaseModel.m
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"

@implementation JYModuleTwoBaseModel

- (JYDetailChartType)chartType {
    JYDetailChartType type = convertChartTypeFrom(self.params[@"type"]);
    return type;
}

- (JYComponentModel *)commponentModel {
    return [JYComponentModel modelWithParams:self.params[@"data"]];
}






JYDetailChartType convertChartTypeFrom(NSString *typeStr) {
    
    JYDetailChartType type = NSNotFound;
    if ([@"banner" isEqualToString:typeStr]) {
        type = JYDetailChartTypeBanner;
    }
    else if ([@"chart" isEqualToString:typeStr]) {
        type = JYDetailChartTypeCartHistogram;
    }
    else if ([@"info" isEqualToString:typeStr]) {
        type = JYDetailChartTypeInfo;
    }
    else if ([@"single_value" isEqualToString:typeStr]) {
        type = JYDetailChartTypeSingleValue;
    }
    else if ([@"bargraph" isEqualToString:typeStr]) {
        type = JYDetailChartTypeBargraph;
    }
    else if ([@"line" isEqualToString:typeStr]) {
        type = JYDetailChartTypeLine;
    }
    else if ([@"tables#v3" isEqualToString:typeStr]) {
        type = JYDetailChartTypeTablesV3;
    }
    
    return type;
}


@end
