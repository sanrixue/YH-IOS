//
//  JYCurveLineView.h
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

@interface JYCurveLineView : JYBaseComponentView <JYBaseComponentViewProtocal>

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL smooth;

@end
