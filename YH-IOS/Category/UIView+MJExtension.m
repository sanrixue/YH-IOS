//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIView+MJExtension.h"

@implementation UIView (MJExtension)

- (CGFloat)mj_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setMj_x:(CGFloat)mj_x
{
    CGRect frame = self.frame;
    frame.origin.x = mj_x;
    self.frame = frame;
}

- (CGFloat)mj_x
{
    return self.frame.origin.x;
}

- (void)setMj_y:(CGFloat)mj_y
{
    CGRect frame = self.frame;
    frame.origin.y = mj_y;
    self.frame = frame;
}

- (CGFloat)mj_y
{
    return self.frame.origin.y;
}

- (void)setMj_w:(CGFloat)mj_w
{
    CGRect frame = self.frame;
    frame.size.width = mj_w;
    self.frame = frame;
}

- (CGFloat)mj_w
{
    return self.frame.size.width;
}

- (void)setMj_h:(CGFloat)mj_h
{
    CGRect frame = self.frame;
    frame.size.height = mj_h;
    self.frame = frame;
}

- (CGFloat)mj_h
{
    return self.frame.size.height;
}

- (void)setMj_size:(CGSize)mj_size
{
    CGRect frame = self.frame;
    frame.size = mj_size;
    self.frame = frame;
}

- (CGSize)mj_size
{
    return self.frame.size;
}

- (void)setMj_origin:(CGPoint)mj_origin
{
    CGRect frame = self.frame;
    frame.origin = mj_origin;
    self.frame = frame;
}

- (CGPoint)mj_origin
{
    return self.frame.origin;
}

+ (instancetype)viewWithXibName:(NSString *)xibName owner:(id)owner{
    if (!xibName) {
        xibName = NSStringFromClass(self);
    }
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:owner options:nil] objectAtIndex:0];
}

/**
 *  <#Description#>
 */
- (void)setBorderColor:(UIColor *)color width:(CGFloat)width
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)corner
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    self.layer.masksToBounds = YES;
    if (corner) {
        [self cornerRadius:corner];
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

-(void)setCircle {
    float radiu = self.frame.size.width / 2;
    [self cornerRadius:radiu];
}

-(void)setCircleTextField {
    float radiu = self.frame.size.height / 2;
    [self cornerRadius:radiu];
}


/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    CGPoint point=CGPointMake(CGRectGetWidth(lineView.frame) * 0.5, CGRectGetHeight(lineView.frame));
    [shapeLayer setPosition:point];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 15);
    CGPathAddLineToPoint(path, NULL, 0, -15);
    
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
@end
