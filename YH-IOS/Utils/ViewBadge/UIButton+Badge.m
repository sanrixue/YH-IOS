//
//  UIButton+Badge.m
//  YH-IOS
//
//  Created by li hao on 16/8/3.
//  Copyright © 2016年 com.intfocus. All rights reserved.
//

#import "UIButton+Badge.h"

@implementation UIButton (Badge)

- (void)showRedIcon{
    UIView *icon = [[UIView alloc] init];
    icon.backgroundColor = [UIColor redColor];
    int x = - 6;
    int y = 0;
    icon.layer.cornerRadius = 3;
    icon.tag = 888;
    icon.frame = CGRectMake(x, y, 6, 6);
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
