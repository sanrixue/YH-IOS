//
//  JYCircleProgressView.h
//  各种报表
//
//  Created by niko on 17/4/24.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBaseComponentView.h"

@interface JYCircleProgressView : JYBaseComponentView <JYBaseComponentViewProtocal>

@property (nonatomic, strong) UIColor *progressColor;
@property (nonatomic, strong) UIColor *progressBackColor;
@property (nonatomic, assign) CGFloat progressWidth;

/* 0.0 - 1.0 */
@property (nonatomic, assign) CGFloat percent;

@end
