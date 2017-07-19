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
    CGFloat flt = [self.hightLightData[@"number"] floatValue] / [self.hightLightData[@"compare"] floatValue];
    flt = !isnan(flt) ? flt : 0.0;
    flt = !isinf(flt) ? flt : [self.hightLightData[@"number"] floatValue];
    NSString *rate = [NSString stringWithFormat:@"%@ %.2f", ([self.hightLightData[@"number"] floatValue] >= [self.hightLightData[@"compare"] floatValue] ? @"+" : @"-"), flt];
    return rate;
}

- (TrendTypeArrow)arrow {
    TrendTypeArrow arrow = [self.hightLightData[@"arrow"] integerValue];
    if ([self.hightLightData[@"arrow"] isKindOfClass:[NSString class]]) {
        arrow = TrendTypeArrowNoArrow;
    }
    return arrow;
}

- (NSString *)saleNumber {
    return numberToString(self.hightLightData[@"number"]);
}

NSString * numberToString(NSNumber *number) {
    return [NSString stringWithFormat:@"%@", number];
}

- (BOOL)percentage {
    return [self.hightLightData[@"percentage"] boolValue];
}

@end
