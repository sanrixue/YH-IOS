//
//  UITabBar+Badge.h
//  practice-notification
//
//  Created by li hao on 16/7/29.
//  Copyright © 2016年 aimer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)displayBadgeOnItemIndex:(NSInteger) index orNot:(BOOL)isOrNot;
- (void)showBadgeOnItemIndex:(NSInteger)index;
- (void)hideBadgeOnItemIndex:(NSInteger)index;

@end
