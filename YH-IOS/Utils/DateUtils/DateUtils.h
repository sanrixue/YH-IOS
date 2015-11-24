//
//  ViewUtils.h
//  iLogin
//
//  Created by lijunjie on 15/5/6.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//
//  说明:
//  处理Date相关的代码合集.

#ifndef ISearch_DateUtils_h
#define ISearch_DateUtils_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
/**
 *  处理Date相关的代码合集.
 */
@interface DateUtils : NSObject

/**
 *  通用函数: 字符串转日期。
 *
 *  @param str    日期字符串
 *  @param format 日期字符串的日期格式
 *
 *  @return 日期字符串对应的日期
 */
+ (NSDate *) strToDate: (NSString *)str Format:(NSString*) format;
/**
 *  通用函数: 日期转成字符串
 *
 *  @param date   待转换的日期
 *  @param format 转换字符串的格式
 *
 *  @return 指定格式的日期字符串
 */
+ (NSString *) dateToStr: (NSDate *)date Format:(NSString*) format;

@end

#endif
