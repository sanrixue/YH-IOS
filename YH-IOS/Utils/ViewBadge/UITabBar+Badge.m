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
  /*  UIView *badgeView = [[UIView alloc] init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 3;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    
    float percentX = (index + 0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * self.bounds.size.width);
    UITabBarItem *tarBarItem = [[self items] objectAtIndex:index];
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    
    badgeView.frame = CGRectMake(x, y,  6,  6);
    [self addSubview:badgeView];
    */
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 6 / 2;
    badgeView.backgroundColor = [UIColor redColor];
    [self addSubview:badgeView];
    
    // 设置小红点的位置
    int i = 0;
    for (UIView* subView in self.subviews){
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            // 找到需要加小红点的view，根据frame设置小红点的位置
            if (i == index) {
                // 数字9为向右边的偏移量，可以根据具体情况调整
                CGFloat x = subView.frame.origin.x + subView.frame.size.width / 2 + 9;
                CGFloat y = 6;
                badgeView.frame = CGRectMake(x, y, 6, 6);
                break;
            }
            i++;
        }
    }
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
