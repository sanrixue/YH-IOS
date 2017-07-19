//
//  UIColor+Utility.m
//  ddd
//
//  Created by niko on 16/8/27.
//  Copyright © 2016年 niko. All rights reserved.
//

#import "UIColor+Utility.h"



@implementation UIColor (Utility)


+ (UIColor *)randomColor {
    
    CGFloat red = (arc4random() % 255 ) / 255.0;
    CGFloat green = (arc4random() % 255 ) / 255.0;
    CGFloat blue = (arc4random() % 255 ) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([hexString hasPrefix:@"#"]) {
        cString = [hexString substringFromIndex:1];
    }
    if ([hexString hasPrefix:@"0X"]) {
        cString = [hexString substringFromIndex:2];
    }
    if ([cString length] != 6) {
        
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *strR = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *strG = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *strB = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:strR] scanHexInt:&r];
    [[NSScanner scannerWithString:strG] scanHexInt:&g];
    [[NSScanner scannerWithString:strB] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0f];
    
}

- (UIColor *)appendAlpha:(CGFloat)alpha {
    const CGFloat *compnents = CGColorGetComponents(self.CGColor);
    CGFloat red = compnents[0];
    CGFloat green = compnents[1];
    CGFloat blue = compnents[1];
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
