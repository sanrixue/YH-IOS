//
//  LoadingView.h
//  YH-IOS
//
//  Created by li hao on 16/10/19.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
@property (nonatomic,strong) UIColor *ballColor;

/** 展示加载动画*/
- (void)showHub;

/**
 *  关闭加载动画
 */
- (void)dismissHub;

@end
