//
//  JYCurveLineView.m
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYCurveLineView.h"
#import "UIBezierPath+curved.h"

@interface JYCurveLineView () {
    
    NSArray<NSString *> *keyPoints;
    __block CGFloat maxValue;
    __block CGFloat minValue;
}

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation JYCurveLineView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%d -- %s", __LINE__, __func__);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self addLine];
}

- (void)refreshSubViewData {
    
    self.dataSource = ((JYDashboardModel *)self.model).chartData;
}

- (void)setDataSource:(NSArray<NSNumber *> *)dataSource {
    
    if ([_dataSource isEqual:dataSource]) {
        return;
    }
    _dataSource = dataSource;
    
    maxValue = 0.0;
    minValue = CGFLOAT_MAX;
    [dataSource enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxValue = maxValue > [obj floatValue] ? maxValue : [obj floatValue];
        minValue = minValue < [obj floatValue] ? minValue : [obj floatValue];
    }];
    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:dataSource.count];
    CGFloat margin = CGRectGetWidth(self.frame) / (dataSource.count - 1);
    for (int i = 0; i < dataSource.count; i++) {
        CGFloat y = CGRectGetHeight(self.frame) * (1 - [dataSource[i] floatValue] / maxValue) + JYViewHeight * 0.4;
        CGFloat x = margin * i + JYViewWidth * 0.05;
        if (i == 0) x += JYDefaultMargin;
        if (i == dataSource.count - 1) x -= JYDefaultMargin;
        
        CGPoint point = CGPointMake(x * 0.9, y * 0.6);
        [points addObject:NSStringFromCGPoint(point)];
    }
    
    keyPoints = [points copy];
    
    [self setNeedsDisplay];
}

- (void)addLine {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGPoint maxP = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGPoint minP = CGPointZero;
    UIBezierPath *layerPath = [UIBezierPath bezierPath];
    for (int i = 0; i < keyPoints.count; i++) {
        CGPoint point = CGPointFromString(keyPoints[i]);
        maxP = maxP.y < point.y ? maxP : point;
        minP = minP.y > point.y ? minP : point;
        
        if (i == 0) {
            [layerPath moveToPoint:point];
        }
        [layerPath addLineToPoint:point];
    }
    if (self.smooth)
        layerPath = [layerPath smoothedPathWithGranularity:20];
    layerPath.lineJoinStyle = kCGLineJoinRound;
    
    CAShapeLayer *linelayer = [CAShapeLayer layer];
    linelayer.lineWidth = 2;
    linelayer.strokeEnd = 0.0;
    linelayer.strokeEnd = 1.0;
    linelayer.path = layerPath.CGPath;
    linelayer.fillColor = [UIColor clearColor].CGColor;
    linelayer.strokeColor = (self.lineColor ?: [UIColor whiteColor]).CGColor;
    linelayer.lineCap = kCALineCapSquare;
    linelayer.lineJoin = kCALineJoinMiter;
    [self.layer addSublayer:linelayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = self.interval;
    [linelayer addAnimation:animation forKey:nil];
    
    NSArray *points = @[NSStringFromCGPoint(minP), NSStringFromCGPoint(maxP)];
    [self performSelector:@selector(addTopPoint:) withObject:points afterDelay:self.interval];
}

- (void)addTopPoint:(NSArray *)points {
    for (int i = 0; i < points.count; i++) {
        CGPoint point = CGPointFromString(points[i]);
        UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        circle.center = point;
        circle.backgroundColor = self.lineColor ?: [UIColor whiteColor];
        circle.layer.cornerRadius = 5;
        [self addSubview:circle];
        
        CGRect frame = CGRectMake(point.x - 10, point.y, 30, 10);
        if (i == 0) frame.origin.y += 8;
        else if (i == 1) frame.origin.y -= 15;
        
        if (frame.origin.x < 10) frame.origin.x += 10;
        
        UILabel *lb = [[UILabel alloc] initWithFrame:frame];
        lb.text = [NSString stringWithFormat:@"%.0f万", i ? maxValue : minValue];
        lb.font = [UIFont systemFontOfSize:10];
        lb.adjustsFontSizeToFitWidth = YES;
        lb.textColor = self.lineColor ?: [UIColor whiteColor];
        [self addSubview:lb];        
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    if ([_lineColor isEqual:lineColor]) return;
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setSmooth:(BOOL)smooth {
    _smooth = smooth;
    [self setNeedsDisplay];
}

@end
