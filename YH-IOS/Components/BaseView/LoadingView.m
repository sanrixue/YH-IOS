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

@interface LoadingView () //<CAAnimationDelegate>

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    CAReplicatorLayer *repLayer = [CAReplicatorLayer layer];
    repLayer.bounds = self.frame;
    repLayer.cornerRadius =10.0;
    repLayer.position = self.center;
    repLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:repLayer];
    
    CALayer *dotLayer        = [CALayer layer];
    dotLayer.bounds          = CGRectMake(0, 0, 15, 15);
    dotLayer.position        = CGPointMake(15, repLayer.frame.size.height/2 );
    dotLayer.backgroundColor = self.ballColor.CGColor;
    dotLayer.cornerRadius    = 7.5;
    CALayer *dotLayer1        = [CALayer layer];
    dotLayer1.bounds          = CGRectMake(0, 0, 15, 15);
    dotLayer1.position        = CGPointMake(35, repLayer.frame.size.height/2 );
    dotLayer1.backgroundColor = self.ballColor.CGColor;
    dotLayer1.cornerRadius    = 7.5;
    CALayer *dotLayer2        = [CALayer layer];
    dotLayer2.bounds          = CGRectMake(0, 0, 15, 15);
    dotLayer2.position        = CGPointMake(55, repLayer.frame.size.height/2 );
    dotLayer2.backgroundColor = self.ballColor.CGColor;
    dotLayer2.cornerRadius    = 7.5;
    
    [repLayer addSublayer:dotLayer];
    [repLayer addSublayer:dotLayer1];
    [repLayer addSublayer:dotLayer2];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration    = 3.0;
    animation.fromValue   = @1;
    animation.toValue     = @0;
    animation.repeatCount = MAXFLOAT;
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.duration    = 2.0;
    animation1.fromValue   = @0;
    animation1.toValue     = @1;
    animation1.repeatCount = MAXFLOAT;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.duration    = 1.0;
    animation2.fromValue   = @0;
    animation2.toValue     = @1;
    animation2.repeatCount = MAXFLOAT;
    
    [dotLayer addAnimation:animation forKey:nil];
    [dotLayer1 addAnimation:animation1 forKey:nil];
    [dotLayer2 addAnimation:animation2 forKey:nil];
}

- (void)dismissHub {
    [self removeFromSuperview];
}
@end
