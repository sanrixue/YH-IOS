//
//  JYAnimationTool.m
//  test2
//
//  Created by haha on 15/8/30.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "JYAnimationTool.h"
#import <UIKit/UIKit.h>

#define JYAnimationToolDuration       0.5
#define JYAnimationToolSpringDuration 0.7
#define JYAnimationToolDamp           0.3
#define JYAnimationToolVelocity       0.3

@implementation JYAnimationTool

+ (void)animateWithAnimations:(void (^)(void))animator{
    [UIView animateWithDuration:JYAnimationToolDuration animations:animator];
}

+ (void)animateWithAnimations:(void (^)(void))animator Completion:(void (^)(BOOL))completion{
    [UIView animateWithDuration:JYAnimationToolDuration animations:animator completion:completion];
}

+ (void)springAnimateWithAnimations:(void (^)(void))animator completion:(void (^)(BOOL))completion{
    [UIView animateWithDuration:JYAnimationToolSpringDuration delay:0 usingSpringWithDamping:JYAnimationToolDamp initialSpringVelocity:JYAnimationToolVelocity options:UIViewAnimationOptionBeginFromCurrentState animations:animator completion:completion];
}

@end
