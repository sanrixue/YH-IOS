//
//  JYBaseModel.h
//  各种报表
//
//  Created by niko on 17/4/30.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TrendTypeArrow) {
    TrendTypeArrowUpRed         = 0,
    TrendTypeArrowUpYellow      = 1,
    TrendTypeArrowUpGreen       = 2,
    TrendTypeArrowDownRed       = 3,
    TrendTypeArrowDownYellow    = 4,
    TrendTypeArrowDownGreen     = 5,
    TrendTypeArrowNoArrow       = NSNotFound,
};


@interface JYBaseModel : NSObject

@property (nonatomic, copy) id params;
@property (nonatomic, assign, readonly) TrendTypeArrow arrow; // 箭头类型

+ (instancetype)modelWithParams:(NSDictionary *)params;

- (UIColor *)arrowToColor;
+ (UIColor *)arrowToColor:(TrendTypeArrow)arrow;


@end
