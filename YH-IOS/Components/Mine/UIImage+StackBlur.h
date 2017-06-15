//
//  UIImage+StackBlur.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (StackBlur)

- (UIImage*) stackBlur:(NSUInteger)radius;
- (UIImage *) normalize ;
+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(NSUInteger)inradius;
+ (UIImage *)imageWithSize:(CGSize)size borderColor:(UIColor* )color borderWidth:(CGFloat)borderWidth;

@end
