//
//  PointHudTool.h
//  JinXiaoEr
//
//  Created by cjg on 17/3/1.
//
//

#import <UIKit/UIKit.h>

@interface PointHudTool : UIView

/**
 show in view

 @param view       view description
 @param title      暂时没用
 @param message    内容
 @param confimBack 点击确认回调
 @param cancleBack 点击取消回调
 
 @return hud
 */
+ (instancetype)pointHudShowInView:(UIView*)view
                             title:(NSString*)title
                           message:(NSString*)message
                        confimBack:(CommonBack)confimBack
                        cancleBack:(CommonBack)cancleBack;

- (void)hide;

@end
