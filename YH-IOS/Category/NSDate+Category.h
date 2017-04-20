//
//  NSDate+Category.h
//  haofang
//
//  Created by Aim on 14-3-19.
//  Copyright (c) 2014年 iflysoft. All rights reserved.
//


/**
 *  为SDK自带的 NSDate 类添加一些实用方法
 */
#import <Foundation/NSDate.h>
#import <Foundation/NSCalendar.h>

#define ONE_MINUTE 60
#define ONE_HOUR  (60*ONE_MINUTE)
#define ONE_DAY   (24*ONE_HOUR)

@interface NSDate (Category)

/** 获取网络时间 */
+ (NSDate*)getInternetTime;

/* 时间字符串 ‘yyyyMMddHHmmss’ 转换为 NSDate */
+ (NSDate*)dateFromDateNumString:(NSString*)timeString;

/* 时间字符串 ‘yyyy-MM-dd HH:mm:ss’ 转换为 NSDate */
+ (NSDate*)dateFromDateTimeString:(NSString*)timeString;

/* 时间字符串 ‘yyyy年MM月dd日’ 转换为 NSDate */
+ (NSDate*)dateFromChineseString:(NSString*)dateString;

/* 日期字符串‘yyyy-MM-dd' 转换为 NSDate */
+ (NSDate *)dateFromDateString:(NSString *)dateStr;

/* 日期字符串‘yyyy-MM' 转换为 NSDate */
+ (NSDate*)dateFromChineseStringMonth:(NSString*)dateString;

/* 日期字符串‘formate' 转换为 NSDate */
+ (NSDate*)dateString:(NSString*)dateString formatString:(NSString*)formateString;


/*修改日期，创建新时间*/
- (NSDate*)updateDateWithhour:(int)h minute:(int)m second:(int)sec;

/*修改日期，创建新时间*/
- (NSDate*)updateDateWithDay:(int)day;

/*修改月份，对当前月份增加或者减少*/
- (NSDate*)moveMonth:(int)value;

/*修改年份，对当前年增加或者减少*/
- (NSDate*)moveYear:(int)value;

/* 当前NSDate转为GMT 时间的字符串 */
- (NSString*)gmtDateTimeString;

/* 当前NSDate转为GMT 日期的字符串 */
- (NSString*)gmtDateString;

/* 当前NSDate转为‘yyyy-MM-dd HH:mm:ss’ 时间的字符串 */
- (NSString*)dateTimeString;

/* 当前NSDate转为‘yyyy-MM-dd HH:mm’ 时间的字符串 */
- (NSString*)dateTimeSimpleString;

/* 当前NSDate转为‘yyyy-MM-dd'字符串 */
- (NSString *)dateString;

/* 当前NSDate转为‘yyyy年MM月dd日'字符串*/
- (NSString *)chineseDateString;

/* 当前NSDate转为‘yyyy年MM月'字符串*/
- (NSString *)chineseYearMonthDateString;

/* 当前NSDate转为‘MM-dd'字符串 */
- (NSString*)monthDayString;

/* 当前NSDate转为‘yyyy-MM'字符串 */
- (NSString*)yearMonthString;

/** 当前NSDate转为‘hh-mm'字符串 */
- (NSString*)timeString;

/* 一年中的第几天 */
- (NSInteger)dayOfYear;

/* 一天从0点开始的时间，单位 秒 */
- (NSInteger)dayTime;

- (NSDateComponents*)components;

/* 比较两个时间之间差距的绝对值 */
- (NSTimeInterval)absIntervalSinceDate:(NSDate *)date;

/* 当前时间对象和现在时间差的绝对值 */
- (NSTimeInterval)absIntervalSinceNow;

/* 当前时间对象和现在时间差 */
- (NSTimeInterval)IntervalSinceDate:(NSDate *)date;

/* 根据时间戳计算天、小时、时、分 */
+ (NSString *)getTimeByInterval:(NSTimeInterval)interval;

/* 获取当前时间戳*/
+ (NSString *)getTimeStamp;

//转化任意日期到当前时区
+(NSDate *)dateToLocalDateFromDate: (NSDate *)forDate;

+(NSString *)stringFromDateNumString:(NSDate *)timeDate;

@end
