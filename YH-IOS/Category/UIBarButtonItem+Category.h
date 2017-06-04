//
//  UIBarButtonItem+Category.h
//  JinXiaoEr
//
//  Created by lin.tk on 2016/11/26.
//
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Category)
+ (instancetype)createBarButtonItemWithImage:(NSString *)imageName target:(id)target action:(SEL)action;

+ (instancetype)createBarButtonItemWithString:(NSString *)string font:(CGFloat)fontSize color:(UIColor *)color target:(id)target action:(SEL)action;

+ (instancetype)createSpaceButton:(CGFloat)padding;

+ (instancetype)spaceFixedItemWithWidth:(CGFloat)width;
@end
