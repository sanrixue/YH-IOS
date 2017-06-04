//
//  UITabBar+TabBarTip.h
//  Chart
//
//  Created by cjg on 16/10/14.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (TabBarTip)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
