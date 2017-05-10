//
//  JYPortraitBar.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYPortraitBar.h"

@interface JYPortraitBar () {
    
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat centerLineX;
    CGFloat barWidth;
}

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *pointList;

@end

@implementation JYPortraitBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {        
        maxValue = 0.0;
        barWidth = kBarHeight;
    }
    return self;
}


- (void)refreshSubViewData {
    // 数据大于5个时，不铺面整个页面
    if (((JYComponentModel *)self.model).chartData.count > 5) {
        barWidth = JYViewWidth / (((JYComponentModel *)self.model).chartData.count * 2);
    }
    self.dataSource = ((JYComponentModel *)self.model).chartData;
}

- (void)setDataSource:(NSArray *)dataSource {
    if (![dataSource isEqual:_dataSource]) {
        _dataSource = dataSource;
        [self formatDataSource];;
    }
}

- (void)drawBarViewWithPoints:(NSArray *)points {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (NSInteger i = 0; i < points.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(CGPointFromString(points[i]).x, JYViewHeight)];
        [path addLineToPoint:CGPointFromString(points[i])];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.strokeStart = 0.0;
        shape.strokeEnd = 1.0;
        shape.lineWidth = barWidth;
        shape.strokeColor = JYColor_ArrowColor_Green.CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.5;
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        [shape addAnimation:animation forKey:nil];
        
        [self.layer addSublayer:shape];
    }
}

- (void)formatDataSource {
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxValue = [obj floatValue] > maxValue ? [obj floatValue] : maxValue;
    }];
    
    _pointList = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    // 计算各值对应的坐标
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        CGFloat value = [self.dataSource[i] floatValue];
        CGFloat barX = (barWidth + barWidth) * i + barWidth / 2 + JYDefaultMargin;
        CGFloat barY = 0.0;
        barY = JYViewHeight - (JYViewHeight * (value / maxValue));
        
        
        [_pointList addObject:NSStringFromCGPoint(CGPointMake(barX, barY))];
    }
    
    [self drawBarViewWithPoints:[_pointList copy]];
    
    // 宽度更新
    if (self.dataSource.count <= 5) {
        
        CGRect frame = self.frame;
        frame.size.width = CGPointFromString([_pointList lastObject]).x + barWidth / 2 + JYDefaultMargin;
        self.frame = frame;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(portraitBar:refreshWidth:)]) {
            [self.delegate portraitBar:self refreshWidth:CGPointFromString([_pointList lastObject]).x + barWidth / 2 + JYDefaultMargin];
        }
    }
}

- (NSArray *)pionts {
    return [_pointList copy];
}

@end
