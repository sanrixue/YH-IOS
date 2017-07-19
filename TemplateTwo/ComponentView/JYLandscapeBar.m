//
//  JYLandscapeBar.m
//  各种报表
//
//  Created by niko on 17/5/4.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYLandscapeBar.h"
#import "JYBargraphModel.h"

@interface JYLandscapeBar () {
    
    CGFloat maxValue;
    CGFloat minValue;
    CGFloat centerLineX;
}

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *pointList;

@end

@implementation JYLandscapeBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        maxValue = 0.0;
        minValue = CGFLOAT_MAX;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self addLayer];
    
}

- (void)refreshSubViewData {
    self.dataSource = [(JYBargraphModel*)self.model seriesData];
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    [self setNeedsDisplay];
}

- (void)addLayer {
    
    [self formatDataSource];
    [self drawBarViewWithPoints:[_pointList copy]];
    
    CGRect frame = self.frame;
    frame.size.height = CGPointFromString([_pointList lastObject]).y + kBarHeight / 2 + JYDefaultMargin;
    self.frame = frame;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(landscapeBar:refreshHeight:)]) {
        [self.delegate landscapeBar:self refreshHeight:CGPointFromString([_pointList lastObject]).y + kBarHeight / 2 + JYDefaultMargin];
    }
}

- (void)drawBarViewWithPoints:(NSArray *)points {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    for (NSInteger i = 0; i < points.count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(centerLineX, CGPointFromString(points[i]).y)];
        [path addLineToPoint:CGPointFromString(points[i])];
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        shape.strokeStart = 0.0;
        shape.strokeEnd = 1.0;
        shape.lineWidth = kBarHeight;
        shape.strokeColor = ((JYBargraphModel*)self.model).seriesColor[i].CGColor;
        shape.fillColor = [UIColor clearColor].CGColor;
        shape.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 0.5;
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        [shape addAnimation:animation forKey:nil];
        
        [self.layer addSublayer:shape];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(centerLineX, 0)];
    [path addLineToPoint:CGPointMake(centerLineX, CGPointFromString(_pointList.lastObject).y + kBarHeight)];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = JYColor_TextColor_Chief.CGColor;
    lineLayer.strokeStart = 0.0;
    lineLayer.strokeEnd = 1.0;
    lineLayer.lineWidth = 0.2;
    [self.layer addSublayer:lineLayer];
    
}

- (void)formatDataSource {
    
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxValue = [obj floatValue] > maxValue ? [obj floatValue] : maxValue;
        minValue = [obj floatValue] > minValue ? minValue : [obj floatValue];
    }];
    
    
    CGFloat total = maxValue;
    if (minValue < 0) {
        total = fabs(minValue) + maxValue;
    }
    
    centerLineX = (fabs(minValue) / total) * (JYViewWidth - JYDefaultMargin);
    
    _pointList = [NSMutableArray arrayWithCapacity:self.dataSource.count];
    // 计算各值对应的坐标
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        CGFloat value = [self.dataSource[i] floatValue];
        CGFloat barY = (JYDefaultMargin + kBarHeight) * i + kBarHeight / 2 + JYDefaultMargin;
        CGFloat barX = 0.0;
        if (value > 0) {
            barX = centerLineX + ((JYViewWidth - JYDefaultMargin / 2) - centerLineX) * (value / maxValue);
        }
        else {
            barX = centerLineX - (centerLineX * fabs(value) / fabs(minValue)) + JYDefaultMargin / 2;
        }
        
        [_pointList addObject:NSStringFromCGPoint(CGPointMake(barX, barY))];
    }
}

- (CGFloat)estimateViewHeight:(JYBaseModel *)model {
    self.dataSource = ((JYBargraphModel *)model).xAxisData;
    [self formatDataSource];
    return CGPointFromString([_pointList lastObject]).y + kBarHeight / 2 + JYDefaultMargin;
}

- (NSArray *)pionts {
    return [_pointList copy];
}

@end
