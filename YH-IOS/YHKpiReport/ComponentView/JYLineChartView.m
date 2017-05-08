//
//  JYLineChartView.m
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYLineChartView.h"

@interface JYLineChartView () <CAAnimationDelegate> {
    
    NSArray<NSString *> *keyPoints;
}

@property (nonatomic, strong) CAShapeLayer *linelayer;

@end

@implementation JYLineChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
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

- (void)setDataSource:(NSArray<NSNumber *> *)dataSource {
    
    if ([_dataSource isEqual:dataSource]) {
        return;
    }
    _dataSource = dataSource;
    
    __block CGFloat maxValue = 0.0;
    [dataSource enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        maxValue = maxValue > [obj floatValue] ? maxValue : [obj floatValue];
    }];
    
    CGFloat margin = CGRectGetWidth(self.frame) / (dataSource.count - 1);
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:dataSource.count];
    for (int i = 0; i < dataSource.count; i++) {
        CGFloat y = CGRectGetHeight(self.frame) * (1 - [dataSource[i] floatValue] / maxValue);
        CGFloat x = margin * i;
        
        CGPoint point = CGPointMake(x, y);
        [points addObject:NSStringFromCGPoint(point)];
    }
    
    keyPoints = [points copy];
    [self setNeedsDisplay];
}

- (void)setInterval:(NSTimeInterval)interval {
    
    [super setInterval:interval];
    [self setNeedsDisplay];
}

- (void)addLine {
    
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < keyPoints.count; i++) {
        CGPoint point = CGPointFromString(keyPoints[i]);
        if (i == 0) {
            [path moveToPoint:point];
        }
        else {
            [path addLineToPoint:point];
        }
    }
    path.lineJoinStyle = kCGLineJoinRound;
    
    _linelayer = [CAShapeLayer layer];
    _linelayer.lineWidth = 3;
    _linelayer.strokeStart = 0.0;
    _linelayer.strokeEnd = 1.0;
    _linelayer.path = path.CGPath;
    _linelayer.fillColor = [UIColor clearColor].CGColor;
    _linelayer.strokeColor = (self.lineColor ?: [UIColor whiteColor]).CGColor;
    _linelayer.lineCap = kCALineCapSquare;
    _linelayer.lineJoin = kCALineJoinMiter;
    
    [self.layer addSublayer:_linelayer];
    
    _linelayer.transform = CATransform3DMakeScale(1, 0.5, 1);
    _linelayer.transform = CATransform3DTranslate(_linelayer.transform, 0, CGRectGetHeight(self.frame) / 2, 0);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @1;
    animation.duration = self.interval;
    [_linelayer addAnimation:animation forKey:@"MPStroke"];
}



@end


