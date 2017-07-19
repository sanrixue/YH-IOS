//
//  UIColor+Utility.h
//  ddd
//
//  Created by niko on 16/8/27.
//  Copyright © 2016年 niko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (UIColor *)appendAlpha:(CGFloat)alpha;

@end
