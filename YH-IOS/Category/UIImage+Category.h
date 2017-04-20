//
//  UIImage+Category.h
//  Chart
//
//  Created by cjg on 16/8/29.
//  Copyright © 2016年 mutouren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
/** 根据颜色生成图片 */
+ (UIImage *)imageWithColor:(UIColor *)color;
/** 防止图片拉伸 */
+ (UIImage *)resizableImage:(NSString *)name;

+ (NSArray*)imageArrWithNameArr:(NSArray*)arr;

//图片放大
+(void)showImage:(UIImageView *)avatarImageView;

//图片比例
-(CGSize)imageWithMaxWidth:(CGFloat)maxWidth;
@end
