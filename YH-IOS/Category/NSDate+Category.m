//
//  NSDate+Category.m
//  haofang
//
//  Created by Aim on 14-3-19.
//  Copyright (c) 2014年 iflysoft. All rights reserved.
//
#import <Foundation/NSDateFormatter.h>
#import "NSDate+Category.h"
#import "NSString+Category.h"

@implementation NSDate (Category)
/**
 
 *  获取网络当前时间
 
 */
+ (NSDate *)getInternetTime{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    // 实例化NSMutableURLRequest，并进行参数配置
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 2];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSError *error = nil;
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    // 处理返回的数据
    //    NSString *strReturn = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if (error) {
        return [NSDate date];
    }
    NSLog(@"response is %@",response);
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [[dMatter dateFromString:date] dateByAddingTimeInterval:60*60*8];
    return netDate;
}

/**
 *  当前NSDate转为字符串
 *
 *     输出的日期字符串形如：@"2010-05-21"
 */
- (NSString *)toDateString {
	return [NSString stringFromDate:self];
}

/* 比较两个时间之间差距的绝对值 */
- (NSTimeInterval)absIntervalSinceDate:(NSDate *)date {
    return fabs([self timeIntervalSinceDate:date]);
}
/* 比较两个时间之间差距 */
- (NSTimeInterval)IntervalSinceDate:(NSDate *)date{
    return [self timeIntervalSinceDate:date];
}

/* 当前时间对象和现在时间差的绝对值 */
- (NSTimeInterval)absIntervalSinceNow {
    return fabs([self timeIntervalSinceNow]);
}

/* 根据时间戳计算天、小时、时、分 */
+ (NSString *)getTimeByInterval:(NSTimeInterval)interval{
    NSString *timeDes = @"";
    int day = interval / ONE_DAY;
    
    int offset=(int)interval % ONE_DAY;
    int hour = offset / ONE_HOUR;
    
    offset= offset%ONE_HOUR;
    int minute = offset/ONE_MINUTE;
    int sec = offset%ONE_MINUTE;
    
    if (day > 0) {
        return [NSString stringWithFormat:@"%d天%d小时%d分%d秒", day, hour, minute, sec];
    }
    
    if (hour > 0) {
        return [NSString stringWithFormat:@"%d小时%d分%d秒", hour, minute, sec];
    }
    
    if (minute > 0) {
        return [NSString stringWithFormat:@"%d分%d秒", minute, sec];
    }
    
    
    if (sec > 0) {
        return [NSString stringWithFormat:@"%d秒", sec];
    }
    return timeDes;
}


-(NSDate*) updateDateWithhour:(int)h minute:(int)m second:(int)sec{
    // Get the year, month, day from the date
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    
    // Set the hour, minute, second to be zero
    components.hour = h;
    components.minute = m;
    components.second = sec;
    
    // Create the date
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate*)updateDateWithDay:(int)day {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    
    // Set the hour, minute, second to be zero
    components.day = day;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    // Create the date
    
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/*修改月份，对当前月份增加或者减少*/
-(NSDate*)moveMonth:(int)value {
    NSDateComponents *components = [self components];
    NSInteger month = components.month + value;
    if (month > 12) {
        month =1;
        components.year +=1;
    }
    else if (month < 1){
        month =12;
        components.year-=1;
    }
    components.month= month;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

/*修改年份，对当前年增加或者减少*/
-(NSDate*)moveYear:(int)value {
    NSDateComponents *components = [self components];
    components.year += value;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSString*)gmtDateTimeString
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format stringFromDate:self];
}

- (NSString*)dateTimeString
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [format stringFromDate:self];
}

-(NSString*)dateTimeSimpleString
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [format stringFromDate:self];
}

-(NSString*)dateString
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:self];
}

- (NSString *)chineseDateString{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    return [format stringFromDate:self];
}

- (NSString *)chineseYearMonthDateString{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];
    return [format stringFromDate:self];
}

- (NSString*)gmtDateString
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:self];
}

-(NSString*)timeString {
    NSDateComponents* components = [self components];
    int hour =(int)[components hour];
    int minute =(int)[components minute];
    return [NSString stringWithFormat:@"%02d:%02d", hour, minute];
}

- (NSString*)monthDayString
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MM-dd"];
    return [format stringFromDate:self];
}

-(NSString*)yearMonthString {
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    return [format stringFromDate:self];
}

-(NSInteger)dayOfYear {
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"D"];
    return [[format stringFromDate:self] integerValue];
}


- (NSInteger)dayTime {
    NSDateComponents* comp = [self components];
    return comp.hour * 3600 + comp.minute* 60 + comp.second;
}


- (NSDateComponents*)components{
    NSCalendar * calendar =[NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
}

+ (NSDate *)dateFromDateNumString:(NSString *)timeString{
    return  [self dateString:timeString formatString:@"yyyyMMddHHmmss"];
}
+(NSString *)stringFromDateNumString:(NSDate *)timeDate{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformatter stringFromDate:timeDate];
}
+ (NSDate*)dateFromDateTimeString:(NSString*)timeString
{
    return  [self dateString:timeString formatString:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate*)dateFromChineseString:(NSString*)dateString
{
    return  [self dateString:dateString formatString:@"yyyy年MM月dd日"];
}

+ (NSDate*)dateFromChineseStringMonth:(NSString*)dateString
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月"];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:[format dateFromString:dateString]];
    NSDate   *localeDate = [[format dateFromString:dateString]  dateByAddingTimeInterval:interval];
    
    
    return localeDate;
}

/**
 *  日期字符串转换为 NSDate
 *
 *     输入的日期字符串形如：@"2010-05-21"
 */
+ (NSDate *)dateFromDateString:(NSString *)dateStr {
    return  [self dateString:dateStr formatString:@"yyyy-MM-dd"];
}


/* 日期字符串‘formate' 转换为 NSDate */
+ (NSDate*)dateString:(NSString*)dateString formatString:(NSString*)formateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formateString];
    NSDate *retDate = [formatter dateFromString:dateString];
    
    return retDate;
}

+ (NSDate *)secondToDay:(unsigned int)second {
    return [[NSDate alloc] initWithTimeIntervalSince1970:second];
}


+ (NSString *)getTimeStamp {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[dat timeIntervalSince1970]];
    
    return timeString;
}

//转化为本地时区日期
+ (NSDate *)dateToLocalDateFromDate:(NSDate *)fromDate
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:fromDate];
    NSDate   *localeDate = [fromDate  dateByAddingTimeInterval:interval];
    return localeDate;
}

@end
