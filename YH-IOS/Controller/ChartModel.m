//
//  ChartModel.m
//  SwiftCharts
//
//  Created by CJG on 17/4/11.
//  Copyright © 2017年 shinow. All rights reserved.
//

#import "ChartModel.h"

@implementation ChartModel
- (instancetype)initWithX:(double)x y:(double)y xString:(NSString *)xString{
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
        _xString = xString;
    }
    return self;
}
@end
