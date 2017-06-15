//
//  UIView+Category.h
//  YH-IOS
//
//  Created by 钱宝峰 on 2017/6/12.
//  Copyright © 2017年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapAction)();

@interface UIView (Category)

- (void)tapHandle:(TapAction)block;
- (void)shakeView;
- (void)shakeRotation:(CGFloat)rotation;
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
