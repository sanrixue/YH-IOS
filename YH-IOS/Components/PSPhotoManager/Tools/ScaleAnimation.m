//
//  ScaleAnimation.m
//  PSPhotoManager
//
//  Created by 雷亮 on 16/8/9.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "ScaleAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@implementation ScaleAnimation

+ (void)addScaleAnimation:(UIView *)totalView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.duration = 0.4f;
    NSValue *value0 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    NSValue *value1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1)];
    NSValue *value2 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1)];
    NSValue *value3 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    NSValue *value4 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)];
    NSValue *value5 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    
    animation.values = @[value0,
                         value1,
                         value2,
                         value3,
                         value4,
                         value5];
    if (totalView.layer) {
        [totalView.layer addAnimation:animation forKey:nil];        
    }
}

@end
