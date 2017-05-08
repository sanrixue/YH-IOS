//
//  JYDashboardModel.m
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYDashboardModel.h"

#import "UIColor+Utility.h"

@implementation JYDashboardModel


- (DashBoardType)dashboardType {
    NSString *type = self.params[@"dashboard_type"];
    DashBoardType dbType;
    if ([type isEqualToString:@"bar"]) {
        dbType = DashBoardTypeBar;
    }
    else if ([type isEqualToString:@"line"]) {
        dbType = DashBoardTypeLine;
    }
    else if ([type isEqualToString:@"number"]) {
        dbType = DashBoardTypeNumber;
    }
    else if ([type isEqualToString:@"ring"]){
        dbType = DashBoardTypeRing;
    }
    return dbType;
}

- (NSString *)unit {
    return self.params[@"unit"];
}

- (NSString *)title {
    return self.params[@"title"];
}

- (NSString *)targeturl {
    return self.params[@"target_url"];
}

- (NSString *)groupName {
    return self.params[@"group_name"];
}

- (BOOL)stick {
    return [self.params[@"is_stick"] integerValue];
}

- (NSArray *)chartData {
    NSArray *ary = self.params[@"data"][@"chart_data"];
    return ary;
}

- (NSDictionary *)hightLightData {
    NSDictionary *high_light = self.params[@"data"][@"high_light"];
    return high_light;
}

- (NSString *)floatRate {
    CGFloat flt = [self.hightLightData[@"compare"] floatValue];
    NSString *rate = flt >= 0 ? [NSString stringWithFormat:@"+ %.1f", flt] : [NSString stringWithFormat:@"- %f", flt];
    return rate;
}

- (TrendTypeArrow)arrow {
    return [self.hightLightData[@"arrow"] integerValue];
}

- (NSString *)saleNumber {
    return numberToString(self.hightLightData[@"number"]);
}

NSString * numberToString(NSNumber *number) {
    return [NSString stringWithFormat:@"%@", number];
}

- (UIColor *)arrowToColor {
    
    return [[self class] arrowToColor:self.arrow];
}

+ (UIColor *)arrowToColor:(TrendTypeArrow)arrow {
    UIColor *color;
    
    switch (arrow) {
        case TrendTypeArrowUpRed:
        case TrendTypeArrowDownRed:
            color = [UIColor colorWithHexString:@"EA4335"];
            break;
            
        case TrendTypeArrowUpGreen:
        case TrendTypeArrowDownGreen:
            color = [UIColor colorWithHexString:@"34AB53"];
            break;
            
        case TrendTypeArrowUpYellow:
        case TrendTypeArrowDownYellow:
            color = [UIColor colorWithHexString:@"FBBC05"];
            break;
            
        default:
            color = [UIColor lightGrayColor]; // 灰色表示未定义
            break;
    }
    
    return color;
}

@end
