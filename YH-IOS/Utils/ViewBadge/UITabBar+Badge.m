//
//  UITabBar+Badge.m
//  practice-notification
//
//  Created by li hao on 16/7/29.
//  Copyright © 2016年 aimer. All rights reserved.
//

#import "UITabBar+Badge.h"
#define  TabbarItemNums 4.0

@implementation UITabBar (Badge)

- (void)displayBadgeOnItemIndex:(NSInteger) index orNot:(BOOL)isOrNot {
    isOrNot ? [self hideBadgeOnItemIndex:index] : [self showBadgeOnItemIndex:index];
}

- (void)showBadgeOnItemIndex:(NSInteger)index {
    UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 3;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    float percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * ([[UIScreen mainScreen] bounds].size.width));
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    badgeView.frame = CGRectMake(x, y,  6,  6);
    [self addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(NSInteger)index {
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if ((subView.tag == 888 + index)) {
            [subView removeFromSuperview];
        }
    }
    
}

@end
