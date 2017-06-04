//
//  JYCloseButton.m
//  各种报表
//
//  Created by niko on 17/4/27.
//  Copyright © 2017年 YMS. All rights reserved.
//

#import "JYBlockButton.h"

@implementation JYCallbackButtonHelper

- (void)callBtnhandler {
    self.button.selected = !self.button.selected;
    self.handler(self.button.selected);
}

@end


@interface JYBlockButton ()
@property (nonatomic, strong) JYCallbackButtonHelper *helper;
@end

@implementation JYBlockButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    JYBlockButton *btn = [super buttonWithType:buttonType];
    if (btn) {
        JYCallbackButtonHelper *helper = [[JYCallbackButtonHelper alloc] init];
        helper.button = btn;
        btn.helper = helper;
        [btn addTarget:btn.helper action:@selector(callBtnhandler) forControlEvents:UIControlEventTouchUpInside];
    }
    return btn;
}

- (void)setHandler:(callHander)handler {
    self.helper.handler = handler;
}

@end
