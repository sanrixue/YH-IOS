//
//  MainTabbarViewController.h
//  Chart
//
//  Created by ice on 16/5/16.
//  Copyright © 2016年 ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITabBarControllerAdditionals.h"

@interface MainTabbarViewController : UITabBarController

+ (instancetype)instance;

+ (instancetype)instanceEnterpriseTabVc;

+ (instancetype)instanceWithArr:(NSArray*)arr;
/** 显示小红点 */
- (void)showBadgeOnItemIndex:(int)index;
/** 掩藏小红点 */
- (void)hideBadgeOnItemIndex:(int)index;

@end
