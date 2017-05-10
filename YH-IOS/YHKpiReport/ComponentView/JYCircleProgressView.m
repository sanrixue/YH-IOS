//
//  JYCircleProgressView.m
//  各种报表
//
//  Created by niko on 17/4/24.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYCircleProgressView.h"

@interface JYCircleProgressView ()

@property (nonatomic, strong) CAShapeLayer *circle;
@property (nonatomic, strong) CAShapeLayer *backLayer;

@end


@implementation JYCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addShapeLayer];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%d -- %s", __LINE__, __func__);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self makeAnimation];
}

- (CAShapeLayer *)circle {
    
    if (!_circle) {
        _circle = [CAShapeLayer layer];
        _circle.fillColor = [UIColor clearColor].CGColor;
        _circle.strokeColor = (self.progressColor ?: [UIColor whiteColor]).CGColor;
        _circle.lineWidth = 5;
        _circle.strokeStart = 0;
        _circle.backgroundColor = [UIColor clearColor].CGColor;
        _circle.lineCap = kCALineCapRound;
        
        [self relayoutLayer];// 更新位置
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:_circle.bounds];
        _circle.path = path.CGPath;
        _circle.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
        _circle.transform = CATransform3DScale(_circle.transform, 0.9, 0.9, 1);
        self.backLayer.path = path.CGPath;
        self.backLayer.transform = CATransform3DScale(self.backLayer.transform, 0.9, 0.9, 1);
        
    }
    return _circle;
}

- (CAShapeLayer *)backLayer {
    if (!_backLayer) {
        
        _backLayer = [CAShapeLayer layer];
        _backLayer.lineWidth = 5;
        _backLayer.strokeStart = 0;
        _backLayer.strokeEnd = 1;
        _backLayer.strokeColor = (self.progressBackColor ?: [UIColor lightTextColor]).CGColor;
        _backLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _backLayer;
}

- (void)relayoutLayer {
    
    CGFloat width = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat height = width;
    CGPoint position = CGPointMake(width / 2.0, height / 2.0 + height * 0.005);
    
    _circle.frame = CGRectMake(0, 0, width, height);
    _circle.position = position;
    
    self.backLayer.frame = CGRectMake(0, 0, width, height);;
    self.backLayer.position = position;
}

- (void)addShapeLayer {
    
    [self.layer addSublayer:self.backLayer];
    [self.layer addSublayer:self.circle];
}

- (void)setProgressWidth:(CGFloat)progressWidth {
    _progressWidth = progressWidth;
    
    self.circle.lineWidth = progressWidth;
    [self setNeedsDisplay];
}

- (void)setProgressColor:(UIColor *)progressColor {
    if (![_progressColor isEqual:progressColor]) {
        _progressColor = progressColor;
    }
    self.circle.strokeColor = _progressColor.CGColor;
}

- (void)setProgressBackColor:(UIColor *)progressBackColor {
    if (![_progressBackColor isEqual:progressBackColor]) {
        _progressBackColor = progressBackColor;
    }
    self.backLayer.strokeColor = _progressBackColor.CGColor;
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent > 1.0 ?: percent;
    if (!self.interval) {
        self.circle.strokeEnd = _percent;
    }
    else {
        [self setNeedsDisplay];
    }
}

- (void)setInterval:(NSTimeInterval)interval{
    [super setInterval:interval];
    [self setNeedsDisplay];
}

- (void)makeAnimation {
    
    if (self.interval == 0) {
        return;
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @(self.percent);
    animation.duration = self.interval;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [_circle addAnimation:animation forKey:@"MPStroke"];
    
}

- (void)refreshSubViewData {
    
    
}

@end

