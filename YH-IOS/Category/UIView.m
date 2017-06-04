//
//  UIView.m
//  RoadRescue
//
//  Created by yh on 16/6/9.
//  Copyright © 2016年 cuicuiTech. All rights reserved.
//

#import "UIView.h"

@implementation UIView(CustomView)

+(id)initFromXib{
    return [[[NSBundle mainBundle] loadNibNamed:[[self class] description] owner:self options:nil] objectAtIndex:0];
}


//+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
//{
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:lineView.bounds];
//    CGPoint point=CGPointMake(CGRectGetWidth(lineView.frame) * 0.5, CGRectGetHeight(lineView.frame));
//    [shapeLayer setPosition:point];
//    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
//    
//    //  设置虚线颜色为blackColor
//    [shapeLayer setStrokeColor:lineColor.CGColor];
//    
//    //  设置虚线宽度
//    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    
//    //  设置线宽，线间距
//    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
//    
//    //  设置路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, SCREEN_WIDTH, 0);
//    CGPathAddLineToPoint(path, NULL, 0, 0);
//    
//    [shapeLayer setPath:path];
//    CGPathRelease(path);
//    
//    //  把绘制好的虚线添加上来
//    [lineView.layer addSublayer:shapeLayer];
//}


//+ (void)drawVerticalDashedLines:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
//{
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    [shapeLayer setBounds:lineView.bounds];
//    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame) / 2)];
//    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
//    //  设置虚线颜色为blackColor
//    [shapeLayer setStrokeColor:lineColor.CGColor];
//    //  设置虚线宽度
//    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
//    [shapeLayer setLineJoin:kCALineJoinRound];
//    //  设置线宽，线间距
//    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
//    //  设置路径
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
//    CGPathAddLineToPoint(path, NULL, 0, 0);
//    [shapeLayer setPath:path];
//    CGPathRelease(path);
//    //  把绘制好的虚线添加上来
//    [lineView.layer addSublayer:shapeLayer];
//}


-(void)removeAllSubviews{
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
}
@end
