//
//  AddShopCarsAnimationTool.h
//  LoveNewBeen
//
//  Created by DY on 16/9/22.
//  Copyright © 2016年 DY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^finishAnimationBlock)(BOOL finish);

@interface AddShopCarsAnimationTool : NSObject <CAAnimationDelegate>

@property (nonatomic,strong) CALayer *layer;
@property (nonatomic,copy) finishAnimationBlock finishAnimationBlock;

+ (instancetype)shareTool;
/**
 *  开始动画
 *
 *  @param view        添加动画的view
 *  @param endRectPoint 下落的位置
 *  @param finish 动画完成回调
 */
- (void) startAnimationWithView: (UIView *)view EndRectPoint: (CGPoint)endRectPoint withfinishBlock :(finishAnimationBlock)finish;

/**
 *  摇晃动画
 *
 */
+ (void)scaleAnimation:(UIView *)scaleView;


@end
