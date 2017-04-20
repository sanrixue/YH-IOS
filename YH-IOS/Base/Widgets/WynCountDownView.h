//
//  WynCountDownView.h
//  YonghuiTest
//
//  Created by Waynn on 16/6/20.
//  Copyright © 2016年 cuicuiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TimerStopBlock)();
typedef void(^CurrentTimer)(NSInteger second);

@interface WynCountDownView : UIView

// 时间戳
@property (nonatomic,assign)NSInteger timestamp;
// 背景
@property (nonatomic,copy)NSString *backgroundImageName;
// 时间停止后回调
@property (nonatomic,copy)TimerStopBlock timerStopBlock;

/** 定时器时时回调 */
@property (nonatomic, strong) CurrentTimer curTime;
/**
 *  创建单例对象
 */
+ (instancetype)wyn_shareCountDown;// 工程中使用的倒计时是唯一的

/**
 *  创建非单例对象
 */
+ (instancetype)wyn_countDown; // 工程中倒计时不是唯一的

@end

