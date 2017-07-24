//
//  NSString+Category.h
//  haofang
//
//  Created by Aim on 14-3-19.
//  Copyright (c) 2014年 iflysoft. All rights reserved.
//



#import "PinYinUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/NSString.h>
#import <UIKit/UIKit.h>
#import "NSString+verification.h"
#import "MJExtensionConst.h"

#define IsEmptyText(str) [NSString isEmptyOrWhitespace:str]
#define SafeText(str) [NSString safeText:str]

/* 对一个字符串进行安全URLEncode */
#define safeURLEncode(str)  (nil == str ? @"" : [str urlEncoding])

/* ---- */
#define empty(str)          (nil == str || [str length] < 1)


/**
 *  SDK自带的 NSString 类添加一些实用方法
 */
@interface NSString (Category)

+ (NSAttributedString *)strToAttriWithStr:(NSString *)htmlStr;

- (UIImage*)imageFromSelf;

+ (BOOL)isEmptyOrWhitespace:(NSString*)string;

/** 删除字符串中的str */
- (NSString*)removeString:(NSString*)str;

/** 去除字符串所有空格和换行符 */
- (NSString*)removeSpace;

/** 防崩，防null */
+ (NSString*)safeText:(NSString*)text;
/* 计算字符串的md5值 */
- (NSString *)md5;

/* 去掉字符串两端的空白字符 */
- (NSString *) trim;

/* 对字符串URLencode编码 */
- (NSString *)urlEncoding;

/* 对字符串URLdecode解码 */
- (NSString *)urlDecoding;

/* 过滤请求协议 */
- (NSString *)trimScheme;

/* 判断一个字符串是否全由字母组成 */
- (BOOL)is_letters;

/** 判断是否为合法密码（8-20位，由字母和数字构成） */
+ (BOOL)isLegalPassword:(NSString*)pwd;

/* 创建一个唯一的UDID */
+ (NSString *)createUDID;

/* 从日期生成字符串 */
+ (NSString *)stringFromDate:(NSDate *)date;

/* 从UIColor对象生成一个字符串 */
+ (NSString *)fromColor:(UIColor *)color;

/* 从字符串生成一个UIColor对象 */
- (UIColor *)toColor;

/* 从字符串生成一个UIColor对象，并指定一个默认颜色 */
- (UIColor *)toColorWithDefaultColor:(UIColor *)defaultColor;

/* 从当前字符串创建一个日期对象 */
- (NSDate *)toDate;

/* 忽略大小写比较两个字符串 */
- (BOOL)equalsIgnoreCase:(NSString *)str;

/* 是否包含特定字符串 */
- (BOOL)contains:(NSString *)str;

/* 把HTML转换为TEXT文本 */
- (NSString *)html2text;

/* 移除一些HTML标签 */
- (NSString *)striptags;

/* 格式化文本 */
- (NSString *)textindent;

/* 获取文本大小 */
- (NSString *)NumberSize2StringSize:(NSInteger)numberSize;

/* 字符串是不是一个纯整数型 */
- (BOOL)isPureInt;

/* 获取 UTF8 编码的 NSData 值 */
- (NSData *)toUtf8Data;

/* 获取中文的第一个首字母 */
+ (NSString *)firstLetter:(NSString *)hanzi;

/* 获取英文的第一个首字母 */
+ (NSString *)firstLetterEnglish:(NSString *)str;


// url相关操作
// 获取url里面的参数
- (NSDictionary *)getURLParams;

// 对字符串添加url参数
- (NSString *)stringByAddingURLParams:(NSDictionary *)params;


/*!
 @method
 @abstract      获取字符串中与初入正则表达式匹配规则符合的字符串数组
 @param         regex : 正则表达式
 @return        返回匹配正则表达式规则的字符串数组
 */
- (NSArray *)getMatchesForRegex:(NSString *)regex;
/*!
 @method
 @abstract      将字符串中与正则表达式匹配的字符串替换成指定的字符串
 @param         regex : 正则表达式
 @param         replace : 替换字符串
 @return        返回替换后的新字符串对象
 */
- (NSString *)stringByReplaceRegex:(NSString *)regex withString:(NSString *)replace;
/**
 *返回值是该字符串所占的大小(width, height)
 *font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *maxSize : 为限制改字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定长值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (CGSize)sizeWithString:(NSString*)str  font:(UIFont*)font maxSize:(CGSize)maxSize minHeight:(CGFloat)minHeight;
@end



@interface NSString(PAPasswordAdditions)

//对密码进行加密
- (NSString *)passwdEncode;

@end

@interface NSString (PACheckValid)
/** 是否合法手机号 */
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidNickName;
- (BOOL)isValidPasswd;
- (BOOL)isValisVerifyCode;
/** 是否合法邮箱 */
- (BOOL)isValidateEmail;
/** 是否合法网址 */
- (BOOL)isValidateWeburl;
@end


@interface NSString (CurrencyForm)

+ (NSString*) stringWithCurrencyRMBFormWithPrice:(CGFloat)price;

+ (NSString*) stringWithCurrencyChineseFormWithPrice:(CGFloat)price;
//得到字符串长度
+(NSUInteger) unicodeLengthOfString: (NSString *) text;

+(BOOL)stringContainsEmoji:(NSString *)string;
@end
