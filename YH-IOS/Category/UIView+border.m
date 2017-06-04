//
//  UIView+border.m
//  teacher
//
//  Created by elwin on 4/16/15.
//  Copyright (c) 2015 elwin. All rights reserved.
//

#import "UIView+border.h"

@implementation UIView (border)

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)setDottedBorderColor:(UIColor *)color width:(CGFloat)width
{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    border.lineWidth = width;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    if (![self.layer.sublayers objectAtIndex:0]) {
        [self.layer insertSublayer:border atIndex:0];
    }
    else
    {
        [self.layer replaceSublayer:[self.layer.sublayers objectAtIndex:0] with:border];
    }
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius
{
    [self setBorderColor:color width:width];
    
    if (radius) {
        [self cornerRadius:radius];
    }
}

- (void)cornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}

- (void)deleteBorder {
    [self setBorderColor:[UIColor clearColor] width:0];
}

-(void)setWidthCircle {
    float radiu = self.frame.size.width / 2;
    [self cornerRadius:radiu];
}

-(void)setHeightCircle {
    float radiu = self.frame.size.height / 2;
    [self cornerRadius:radiu];
}

@end
