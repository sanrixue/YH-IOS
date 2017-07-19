//
//  JYModuleTwoBaseModel.m
//  各种报表
//
//  Created by niko on 17/5/8.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYModuleTwoBaseModel.h"
#import "JYBannerModel.h"
#import "JYChartModel.h"
#import "JYSingleValueModel.h"
#import "JYBargraphModel.h"
#import "JYInfoModel.h"
#import "JYExcelModel.h"

@implementation JYModuleTwoBaseModel

+ (instancetype)moduleTwoBaseModelWithParams:(NSDictionary *)params {
    JYModuleTwoBaseModel *secondModel = nil;
    JYDetailChartType type = convertChartTypeFrom(params);
    switch (type) {
        case JYDetailChartTypeBanner:
            secondModel = [JYBannerModel modelWithParams:params];
            break;
        case JYDetailChartTypeLine:
        case JYDetailChartTypeCartHistogram:
            secondModel = [JYChartModel modelWithParams:params];
            break;
        case JYDetailChartTypeInfo:
            secondModel = [JYInfoModel modelWithParams:params];
            break;
        case JYDetailChartTypeSingleValue:
            secondModel = [JYSingleValueModel modelWithParams:params];
            break;
        case JYDetailChartTypeBargraph:
            secondModel = [JYBargraphModel modelWithParams:params];
            break;
        case JYDetailChartTypeTables:
            secondModel = [JYExcelModel modelWithParams:params];
            break;
            
        default:
            secondModel = [super modelWithParams:params];
            break;
    }
    return secondModel;
}


- (JYDetailChartType)chartType {
    JYDetailChartType type = convertChartTypeFrom(self.params);
    return type;
}

- (NSArray<NSNumber *> *)xAxisData {
    return self.params[@"data"][@"xAxis"];
}

- (NSArray<NSNumber *> *)yAxisData {
    return self.params[@"data"][@"yAxis"];
}

- (NSDictionary *)configInfo {
    return self.params[@"config"];
}


JYDetailChartType convertChartTypeFrom(NSDictionary *info) {
    
    NSString *typeStr = info[@"type"];
    JYDetailChartType type = NSNotFound;
    if ([@"banner" isEqualToString:typeStr]) {
        type = JYDetailChartTypeBanner;
    }
    else if ([@"chart" isEqualToString:typeStr]) {
        
        NSDictionary *configInfo = info[@"config"][@"series"][0];
        NSString *chartType = configInfo[@"type"];
        
        if ([chartType isEqualToString:@"line"]) {
            type = JYDetailChartTypeLine;
        }
        else if ([chartType isEqualToString:@"bar"]) {
            type = JYDetailChartTypeCartHistogram; // 纵向柱状图
        }
    }
    else if ([@"info" isEqualToString:typeStr]) {
        type = JYDetailChartTypeInfo;
    }
    else if ([@"single_value" isEqualToString:typeStr]) {
        type = JYDetailChartTypeSingleValue;
    }
    else if ([@"bargraph" isEqualToString:typeStr]) {
        type = JYDetailChartTypeBargraph; // 横向条状图
    }
    else if ([@"tables" isEqualToString:typeStr]) {
        type = JYDetailChartTypeTables;
    }
    
    return type;
}


@end
