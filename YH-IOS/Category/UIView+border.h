//
//  UIView+border.h
//  teacher
//
//  Created by elwin on 4/16/15.
//  Copyright (c) 2015 elwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (border)

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width;

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius;

- (void)setDottedBorderColor:(UIColor *)color width:(CGFloat)width;

- (void)cornerRadius:(CGFloat)radius;

- (void)deleteBorder;

- (void)setWidthCircle;

-(void)setHeightCircle;
@end
