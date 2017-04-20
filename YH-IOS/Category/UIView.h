//
//  UIView.h
//  RoadRescue
//
//  Created by yh on 16/6/9.
//  Copyright © 2016年 cuicuiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(CustomView)
/**
 *  从xib初始化
 *
 *  @return 返回实例
 */
+(id)initFromXib;
/** 画横虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
// **/
//+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
///** 画竖虚线
// ** lineView:	   需要绘制成虚线的view
// ** lineLength:	 虚线的宽度
// ** lineSpacing:	虚线的间距
// ** lineColor:	  虚线的颜色
// **/
//+ (void)drawVerticalDashedLines:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;
-(void)removeAllSubviews;
@end
