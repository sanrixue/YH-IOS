//
//  JYSingleValueModel.m
//  各种报表
//
//  Created by niko on 17/5/13.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYSingleValueModel.h"

@implementation JYSingleValueModel

- (TrendTypeArrow)arrow {
    return [self.configInfo[@"state"][@"color"] integerValue];
}

- (UIColor *)stateColor {
    return self.arrowToColor;
}

- (NSString *)mainData {
    return [NSString stringWithFormat:@"%@", self.configInfo[@"main_data"][@"data"]];
}

- (NSString *)subData {
    return [NSString stringWithFormat:@"%@", self.configInfo[@"sub_data"][@"data"]];
}

- (NSString *)mainName {
    return self.configInfo[@"main_data"][@"name"];
}

- (NSString *)subName {
    return self.configInfo[@"sub_data"][@"name"];
}

- (NSString *)floatRatio {
    
    CGFloat ratio = ([self.mainData floatValue] - [self.subData floatValue]) / [self.subData floatValue] * 100;
    return [NSString stringWithFormat:@"%@%0.2f％", (ratio > 0 ? @"+" : @"") ,ratio];
}


@end
