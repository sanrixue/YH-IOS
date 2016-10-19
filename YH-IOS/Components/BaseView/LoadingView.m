//
//  LoadingView.m
//  YH-IOS
//
//  Created by li hao on 16/10/19.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "LoadingView.h"

#define KORIGIN_X    self.frame.origin.x
#define KORIGIN_Y    self.frame.origin.y
#define KWIDTH       self.frame.size.width
#define KHEIGHT      self.frame.size.height
#define KBALL_RADIUS  20

@interface LoadingView ()<CAAnimationDelegate>
@property (strong, nonatomic)UIView *ball_1;
@property (strong, nonatomic)UIView *ball_2;
@property (strong, nonatomic)UIView *ball_3;

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIVisualEffectView *bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        bgView.alpha = 0.9f;
        bgView.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
        bgView.layer.cornerRadius = KBALL_RADIUS / 2;
        bgView.clipsToBounds = YES;
        [self addSubview:bgView];
    }
    return self;
}

- (UIColor *)ballColor {
    if (_ballColor) {
        return _ballColor;
    }
    return [UIColor greenColor];
}

- (void)showHub {
    CGFloat ballH = KHEIGHT / 2 - KBALL_RADIUS * 0.5;
    UIView *ball_1 = [[UIView alloc]initWithFrame:CGRectMake(KWIDTH / 2 - KBALL_RADIUS * 1.5, ballH, KBALL_RADIUS,KBALL_RADIUS)];
    ball_1.layer.cornerRadius = KBALL_RADIUS / 2;
    ball_1.backgroundColor = self.ballColor;
    [self addSubview:ball_1];
    self.ball_1 = ball_1;
    
    UIView *ball_2 = [[UIView alloc]initWithFrame:CGRectMake(KWIDTH / 2 - KBALL_RADIUS * 0.5, ballH, KBALL_RADIUS,KBALL_RADIUS)];
    ball_2.layer.cornerRadius = KBALL_RADIUS / 2;
    ball_2.backgroundColor = self.ballColor;
    [self addSubview:ball_2];
    self.ball_2 = ball_2;
    
    UIView *ball_3 = [[UIView alloc]initWithFrame:CGRectMake(KWIDTH / 2 + KBALL_RADIUS * 0.5, ballH, KBALL_RADIUS,KBALL_RADIUS)];
    ball_3.layer.cornerRadius = KBALL_RADIUS / 2;
    ball_3.backgroundColor = self.ballColor;
    [self addSubview:ball_3];
    self.ball_3 = ball_3;
}

- (void)rotationAnimation {
    CGPoint centerPoint = CGPointMake(KWIDTH / 2, KHEIGHT / 2);
    CGPoint centerBall_1 = CGPointMake(KWIDTH / 2 - KBALL_RADIUS, KHEIGHT / 2);
    CGPoint centerBall_2 = CGPointMake(KWIDTH / 2 + KBALL_RADIUS, KHEIGHT / 2);
    
    //第一个圆的曲线
    
    UIBezierPath *path_ball_1 = [UIBezierPath bezierPath];
    [path_ball_1 moveToPoint:centerBall_1];
    
    [path_ball_1 addArcWithCenter:centerPoint radius:KBALL_RADIUS startAngle:M_PI endAngle:2*M_PI clockwise:NO];
    UIBezierPath *path_ball_1_1 = [UIBezierPath bezierPath];
    [path_ball_1_1 addArcWithCenter:centerPoint radius:KBALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    [path_ball_1 appendPath:path_ball_1_1];
    
    // 2.2 第一个圆的动画
    CAKeyframeAnimation *animation_ball_1=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation_ball_1.path = path_ball_1.CGPath;
    animation_ball_1.removedOnCompletion = NO;
    animation_ball_1.fillMode = kCAFillModeForwards;
    animation_ball_1.calculationMode = kCAAnimationCubic;
    animation_ball_1.repeatCount = 1;
    animation_ball_1.duration = 1.4;
    animation_ball_1.delegate = self;
    animation_ball_1.autoreverses = NO;
    animation_ball_1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.ball_1.layer addAnimation:animation_ball_1 forKey:@"animation"];
    
    // 2.1 第一个圆的曲线
    UIBezierPath *path_ball_3 = [UIBezierPath bezierPath];
    [path_ball_3 moveToPoint:centerBall_2];
    
    [path_ball_3 addArcWithCenter:centerPoint radius:KBALL_RADIUS startAngle:0 endAngle:M_PI clockwise:NO];
    UIBezierPath *path_ball_3_1 = [UIBezierPath bezierPath];
    [path_ball_3_1 addArcWithCenter:centerPoint radius:KBALL_RADIUS startAngle:M_PI endAngle:M_PI*2 clockwise:NO];
    [path_ball_3 appendPath:path_ball_3_1];
    
    // 2.2 第2个圆的动画
    CAKeyframeAnimation *animation_ball_3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation_ball_3.path = path_ball_3.CGPath;
    animation_ball_3.removedOnCompletion = NO;
    animation_ball_3.fillMode = kCAFillModeForwards;
    animation_ball_3.calculationMode = kCAAnimationCubic;
    animation_ball_3.repeatCount = 1;
    animation_ball_3.duration = 1.4;
    animation_ball_3.delegate = self;
    animation_ball_3.autoreverses = NO;
    animation_ball_3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.ball_3.layer addAnimation:animation_ball_3 forKey:@"rotation"];
    
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    [self rotationAnimation];
}

- (void)animationDidStart:(CAAnimation *)anim{
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.ball_1.transform = CGAffineTransformMakeTranslation(-KBALL_RADIUS, 0);
        self.ball_1.transform = CGAffineTransformScale(self.ball_1.transform, 0.7, 0.7);
        
        self.ball_3.transform = CGAffineTransformMakeTranslation(KBALL_RADIUS, 0);
        self.ball_3.transform = CGAffineTransformScale(self.ball_3.transform, 0.7, 0.7);
        
        
        self.ball_2.transform = CGAffineTransformScale(self.ball_2.transform, 0.7, 0.7);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0.05 options:UIViewAnimationOptionCurveEaseIn  | UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.ball_1.transform = CGAffineTransformIdentity;
            self.ball_3.transform = CGAffineTransformIdentity;
            self.ball_2.transform = CGAffineTransformIdentity;
        } completion:NULL];
        
    }];
}

- (void)dismissHub{
    
}

@end
