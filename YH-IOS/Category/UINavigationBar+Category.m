//
//  UINavigationBar+Category.m
//  haofang
//
//  Created by Aim on 14-4-28.
//  Copyright (c) 2014年 iflysoft. All rights reserved.
//

#import "UINavigationBar+Category.h"
#import "BasicTool.h"

@implementation UINavigationBar (Category)

- (void)customSetBackgroundColor:(UIColor *)color{
    if (SYSTEM_VERSION<7.0) {
        self.clipsToBounds = YES;
        self.shadowImage = [[UIImage alloc] init];
        self.tintColor = color;
        
    }else{
        self.barTintColor = color;
    }
    self.translucent = NO;
//    [self setNavigationTitleStyle];
}
//
//- (void)setNavigationTitleStyle{
//    NSDictionary *navTitleDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                 [UIFont systemFontOfSize:18],UITextAttributeFont,
//                                 [UIColor PABlackTextColor],UITextAttributeTextColor,
//                                 [NSValue valueWithCGSize:CGSizeMake(2.0, 2.0)],UITextAttributeTextShadowOffset,
//                                 [UIColor clearColor],UITextAttributeTextShadowColor,
//                                 nil];
//    [self setTitleTextAttributes:navTitleDic];
//}

@end
