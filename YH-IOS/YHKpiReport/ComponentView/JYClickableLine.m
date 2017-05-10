//
//  JYClickableLine.m
//  各种报表
//
//  Created by niko on 17/5/7.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYClickableLine.h"

@interface JYClickableLine () {
    
    NSArray<NSString *> *keyPoints;
    __block CGFloat maxValue;
    CGFloat margin;
    CAShapeLayer *linelayer;
}


@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *pointList;
@property (nonatomic, strong) UIView *flagPoint;

@end

@implementation JYClickableLine

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self refreshSubViewData];
        [self addGesture];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%d -- %s", __LINE__, __func__);
}

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizer:)];
    [self addGestureRecognizer:pan];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self addLine];
}

- (void)setDataList:(NSArray *)dataList {
    if (![_dataList isEqual:dataList]) {
        _dataList = dataList;
        self.dataSource = dataList;
    }
}

- (void)refreshSubViewData {
    
    self.dataSource = self.dataList;
}

- (UIView *)flagPoint {
    if (!_flagPoint) {
        _flagPoint = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _flagPoint.backgroundColor = JYColor_ArrowColor_Red;
        _flagPoint.hidden = YES;
        [self addSubview:_flagPoint];
    }
    return _flagPoint;
}

- (void)setDataSource:(NSArray<NSNumber *> *)dataSource {
    
    if (![_dataSource isEqual:dataSource]) {
        _dataSource = dataSource;        
        [self formatterPoints];
        
        [self setNeedsDisplay];
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    if (![_lineColor isEqual:lineColor]) {
        _lineColor = lineColor;
        linelayer.strokeColor = lineColor.CGColor;
    }
    [self setNeedsDisplay];
}

- (void)formatterPoints {
    
    maxValue = 0.0;
    [_dataSource enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxValue = maxValue > [obj floatValue] ? maxValue : [obj floatValue];
    }];
    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:_dataSource.count];
    margin = CGRectGetWidth(self.frame) / (_dataSource.count - 1);
    for (int i = 0; i < _dataSource.count; i++) {
        CGFloat y = CGRectGetHeight(self.frame) * (1 - [_dataSource[i] floatValue] / maxValue) + JYViewHeight * 0.1;
        CGFloat x = margin * i;
        if (i == 0) x += JYDefaultMargin;
        if (i == _dataSource.count - 1) x -= JYDefaultMargin;
        
        CGPoint point = CGPointMake(x, y * 0.9);
        [points addObject:NSStringFromCGPoint(point)];
    }
    
    keyPoints = [points copy];
}

- (NSArray *)points {
    return [keyPoints copy];
}

- (void)addLine {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    UIBezierPath *layerPath = [UIBezierPath bezierPath];
    for (int i = 0; i < keyPoints.count; i++) {
        CGPoint point = CGPointFromString(keyPoints[i]);
        if (i == 0) {
            [layerPath moveToPoint:point];
        }
        [layerPath addLineToPoint:point];
    }
    layerPath.lineJoinStyle = kCGLineJoinRound;
    
    linelayer = [CAShapeLayer layer];
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
    animation.duration = 0.5;
    [linelayer addAnimation:animation forKey:nil];
    
}


- (void)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    
    [self findNearestKeyPointOfPoint:[gestureRecognizer locationInView:self]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickableLine:didSelected:)]) {
        [self.delegate clickableLine:self didSelected:[gestureRecognizer locationInView:self]];
    }
}

// 寻找最近的点
- (void)findNearestKeyPointOfPoint:(CGPoint)point {
    self.flagPoint.hidden = NO;
    for (NSInteger i = 0; i < keyPoints.count; i++) {
        
        CGPoint keyPoint = CGPointFromString(keyPoints[i]);
        if (fabs(keyPoint.x - point.x) < margin / 2) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(clickableLine:didSelected:data:)]) {
                [self.delegate clickableLine:self didSelected:i data:self.dataSource[i]];
            }
            
            //NSLog(@"the nearest point is index at %zi", i + 1);
            [UIView animateWithDuration:0.25 animations:^{
                self.flagPoint.center = keyPoint;
            }];
        }
    }
}


@end
