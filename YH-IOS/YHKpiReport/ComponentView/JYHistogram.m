//
//  JYHistogram.m
//  各种报表
//
//  Created by niko on 17/4/25.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYHistogram.h"

@interface JYHistogram () {
    
}


@end

@implementation JYHistogram

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%d -- %s", __LINE__, __func__);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawSubLayer];
}

- (void)refreshSubViewData {
    self.dataSource = ((JYDashboardModel *)self.model).chartData;
}

- (void)drawSubLayer {
    
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    NSInteger barCount = _dataSource.count * 2;
    __block CGFloat max = 0;
    CGFloat widthPerBar = CGRectGetWidth(self.frame) / (14.0 * 2);// !!!: 最大支持14条柱子
    [_dataSource enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        max = [obj floatValue] > max ? [obj floatValue] : max;
    }];
    
    for (int i = 0; i < barCount; i++) {
        if (i % 2 != 0) continue;
        CGFloat height = CGRectGetHeight(self.frame) * ([_dataSource[i / 2] floatValue] / max);
        CGRect frame = CGRectMake(i * widthPerBar + widthPerBar / 2, CGRectGetHeight(self.frame) - height, widthPerBar, height);
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint start = CGPointMake(frame.origin.x + widthPerBar / 2, CGRectGetHeight(self.frame));
        CGPoint end = CGPointMake(frame.origin.x + widthPerBar / 2, frame.origin.y);
        [path moveToPoint:start];
        [path addLineToPoint:end];
        
        CAShapeLayer *barLayer = [CAShapeLayer layer];
        barLayer.path = path.CGPath;
        barLayer.strokeStart = 0.0;
        barLayer.strokeEnd = 1.0;
        barLayer.lineWidth = widthPerBar;
        barLayer.lineCap = self.lineCap ?: kCALineCapRound;
        barLayer.fillColor = [UIColor clearColor].CGColor;
        barLayer.strokeColor = (self.barColor ?: [UIColor whiteColor]).CGColor;
        if (i == barCount - 2) {
            barLayer.strokeColor = _lastBarColor.CGColor;
        }
        if (self.interval) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @0.0;
            animation.toValue = @1.0;
            animation.duration = self.interval;
            [barLayer addAnimation:animation forKey:nil];
        }
        [self.layer addSublayer:barLayer];
        barLayer.transform = CATransform3DMakeScale(1, 0.9, 1);
        barLayer.transform = CATransform3DTranslate(barLayer.transform, 0, self.frame.size.height * 0.1, 0);
    }
}

- (void)setDataSource:(NSArray<NSNumber *> *)dataSource {
    
    if ([_dataSource isEqual:dataSource]) return;
    _dataSource = dataSource;
    [self setNeedsDisplay];
}

- (void)setLastBarColor:(UIColor *)lastBarColor {
    if ([_dataSource isEqual:lastBarColor]) return;
    _lastBarColor = lastBarColor;
    [self setNeedsDisplay];
}

- (void)setBarColor:(UIColor *)barColor {
    if ([_dataSource isEqual:barColor]) return;
    _barColor = barColor;
    [self setNeedsDisplay];
}

- (void)setInterval:(NSTimeInterval)interval {
    [super setInterval:interval];
    [self setNeedsDisplay];
}

@end
