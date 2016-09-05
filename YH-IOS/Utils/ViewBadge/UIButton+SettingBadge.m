//
//  UIButton+SettingBadge.m
//  YH-IOS
//
//  Created by li hao on 16/9/4.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "UIButton+SettingBadge.h"

@implementation UIButton (SettingBadge)

- (void)showRedIcon {
    UIView *icon = [[UIView alloc] init];
    icon.backgroundColor = [UIColor redColor];
    int x = 45;
    int y = 20;
    icon.layer.cornerRadius = 3.5;
    icon.tag = 888;
    icon.frame = CGRectMake(x, y, 7, 7);
    [self addSubview:icon];
}

- (void)hideRedIcon {
    for (UIView *view in self.subviews) {
        if ((view.tag == 888))  {
            [view removeFromSuperview];
        }
    }
    
}

@end
