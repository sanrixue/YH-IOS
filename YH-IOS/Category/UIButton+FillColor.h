//
//  UIButton.h
//  cosplay
//
//  Created by MAC on 15/6/3.
//  Copyright (c) 2015年 nd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    DEFUALT_BUTTON_TYPENUM1, //0
    DEFUALT_BUTTON_TYPENUM2 //1白底金边
}button_type;

typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleTop, // image在上，label在下
    ButtonEdgeInsetsStyleLeft, // image在左，label在右
    ButtonEdgeInsetsStyleBottom, // image在下，label在上
    ButtonEdgeInsetsStyleRight // image在右，label在左
};


@interface UIButton (FillColor)
/**
 *  设置button背景色，采用填充纯色image的方式
 *
 *  @param backgroundColor 背景颜色
 *  @param state           状态
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;


/**
 样式1：app主色调，白色12号字体，圆角2
 */
- (void)style1;

/**
 样式2：背景无，蓝色12号字体，圆角无
 */
- (void)style2;

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end
