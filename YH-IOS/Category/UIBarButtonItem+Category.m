//
//  UIBarButtonItem+Category.m
//  JinXiaoEr
//
//  Created by lin.tk on 2016/11/26.
//
//

#import "UIBarButtonItem+Category.h"

@implementation UIBarButtonItem (Category)

+ (instancetype)createBarButtonItemWithImage:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button sizeToFit];
    if (action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[self alloc] initWithCustomView:button];
}


+ (instancetype)createBarButtonItemWithString:(NSString *)string font:(CGFloat)fontSize color:(UIColor *)color target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:string forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button sizeToFit];
    if (action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[self alloc] initWithCustomView:button];
}


+ (instancetype)createSpaceButton:(CGFloat)padding {
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexSpacer.width = padding;
    return flexSpacer;
}

+ (instancetype)spaceFixedItemWithWidth:(CGFloat)width {
    UIBarButtonItem *seperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    seperator.width = width;//此处修改到边界的距离，请自行测试
    
    return seperator;
}
@end
