//
//  GUATool.h
//  ShenghuoJia
//
//  Created by Guava on 15/12/16.
//  Copyright © 2015年 YongHui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GUAToolShow(message,time) [GUATool showMessage:message waitingTime:time]


@interface GUATool : NSObject

+(void)showDialog:(NSString*)title
          message:(NSString*)message
      waitingTime:(NSTimeInterval)time;

+(void)showMessage:(NSString*)message
      waitingTime:(NSTimeInterval)time;

+(CGFloat)calculateLabelHeightWithWidth:(CGFloat) widthOfLabel
                         contentText:(NSString *) content
                                   font:(UIFont *)contentFont;

+ (BOOL)checkUserIdCard: (NSString *) idCard;
+ (BOOL)simpleYHCard:(NSString *)num;
+ (BOOL)simpleCellphoneNumberCheck:(NSString *)cellNumber;
/** 展示菊花图 */
+ (void)showGifImageHUDInView:(UIView*)view;
/** 掩藏菊花图 */
+ (void)hideGifImageHUDInView:(UIView*)view;
/** 移除所有菊花图 */
+ (void)hideAllGifImageHUD;

+ (BOOL)haveHUDInView:(UIView*)view;

+ (void)showMessage:(NSString*)message needGif:(BOOL)need inView:(UIView*)view;
+ (void)hideHUDInView:(UIView*)view afterTime:(NSTimeInterval)time;
+ (void)showMessage:(NSString*)message needGif:(BOOL)need inView:(UIView*)view afterTime:(NSTimeInterval)time showTime:(NSTimeInterval)showTime;



@end
