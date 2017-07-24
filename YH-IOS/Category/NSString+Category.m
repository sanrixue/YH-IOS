//
//  NSString+Category.m
//  haofang
//
//  Created by Aim on 14-3-19.
//  Copyright (c) 2014年 iflysoft. All rights reserved.
//
#import "NSString+Category.h"
#import "NSDate+Category.h"
#import <UIKit/UIInterface.h>

@implementation NSString (Category)

+ (NSAttributedString *)strToAttriWithStr:(NSString *)htmlStr{
    return [[NSAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding]
                                            options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                 documentAttributes:nil
                                              error:nil];
}

+ (NSString *)safeText:(NSString *)text{
    if ([self isEmptyOrWhitespace:text]) {
        return @"";
    }
    return text;
}

+ (NSString *)removeSpace:(NSString *)str{
    if ([self isEmptyOrWhitespace:str]) {
        return @"";
    }
    str = [str stringByReplacingOccurrencesOfString:@" "withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\r"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t"withString:@""];
    return str;
}

- (NSString *)removeString:(NSString *)str{
    return [self stringByReplacingOccurrencesOfString:str withString:@""];
}

- (NSString *)removeSpace{
    if ([NSString isEmptyOrWhitespace:self]) {
        return @"";
    }
    NSString *str;
    str = [self stringByReplacingOccurrencesOfString:@" "withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\r"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n"withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t"withString:@""];
    return str;
}

/**
 * 计算字符串的md5值
 *
 **/
- (NSString *)md5 {
	if(self == nil || [self length] == 0){
		return nil;
	}

	const char *src = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];

	CC_MD5(src, strlen(src), result);

	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
		result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
		result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
	];
}

/**
 * 去掉字符串两端的空白字符
 *
 **/
- (NSString *) trim {
	if(nil == self){
		return nil;
	}

	NSMutableString *re = [NSMutableString stringWithString:self];
	CFStringTrimWhitespace((CFMutableStringRef)re);
	return (NSString *)re;
}

/**
 * 对字符串URLencode编码
 **/
// FIX: error method
- (NSString *)urlEncoding {
	NSString *result = (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)self,NULL,(CFStringRef)@"!#[]'*;/?:@&=$+{}<>,",kCFStringEncodingUTF8);
	return result;
}


/**
 * 对字符串URLdecode解码
 **/
- (NSString *)urlDecoding {
    NSString* result = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	return result;
}

/**
**
* 过滤请求协议
**/
- (NSString *)trimScheme {
    NSRange range = [self rangeOfString:@"://"];
    if (range.length != 0) {
        return [self substringFromIndex:range.location + range.length];
    }
    return nil;
}

/**
 * 判断一个字符串是否全由字母组成
 *
 * @return NSString
 **/
- (BOOL)is_letters {
	NSString *regPattern = @"[a-zA-Z]+";
	NSPredicate *testResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regPattern];
	return [testResult evaluateWithObject:self];
}


+ (BOOL)isLegalPassword:(NSString *)pwd{
    if ([self isEmptyOrWhitespace:pwd]) {
        return 0;
    }
    NSString *str = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
    NSPredicate *testResult = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [testResult evaluateWithObject:pwd];
}

/**
 * 创建一个唯一的UDID
 *
 * @return NSString
 **/
+ (NSString *)createUDID {
	CFUUIDRef udid = CFUUIDCreate(nil);
	NSString *strUDID = (__bridge_transfer NSString *)CFUUIDCreateString(nil, udid);
	CFRelease(udid);
	return strUDID;
}

/**
 * 从日期生成字符串
 *
 * @return NSString
 **/
+ (NSString *)stringFromDate:(NSDate *)date {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString *retStr = [formatter stringFromDate:date];

	return retStr;
}

/**
 * 从UIColor对象生成一个字符串
 *
 * @return NSString
 **/
+ (NSString *)fromColor:(UIColor *)color {
	if (nil == color) {
		return nil;
	}

	CGColorRef c = color.CGColor;
	const CGFloat *components = CGColorGetComponents(c);
	size_t numberOfComponents = CGColorGetNumberOfComponents(c);
	NSMutableString *str = [NSMutableString stringWithCapacity:0];
    unsigned int hexC=0;

	[str appendString:@"#"];

    if (numberOfComponents != 2 && numberOfComponents != 4) {
        return nil;
    }

    for (size_t i = 0; i < numberOfComponents - 1; ++i) {
        hexC = (unsigned int)floor(255.0f * components[i]);
        [str appendString:[NSString stringWithFormat:@"%02x", hexC & 255]];
    }

    if (numberOfComponents == 2) {
        size_t padNum = 4 - numberOfComponents;

        for (size_t i = 0; i < padNum; ++i) {
            [str appendString:[NSString stringWithFormat:@"%02x", hexC & 255]];
        }
    }

    hexC = (unsigned int)floor(255.0f * components[numberOfComponents - 1]);
    hexC = (255 - hexC) & 255;

    if (hexC != 0) {
        [str appendString:[NSString stringWithFormat:@"%02x", hexC]];
    }

	return str;
}

/**
 * 从字符串生成一个UIColor对象
 *
 * @return UIColor
 **/
- (UIColor *)toColor {
	return [self toColorWithDefaultColor:[UIColor blackColor]];
}

/**
 * 从字符串生成一个UIColor对象，并指定一个默认颜色
 *
 * @return UIColor
 **/
- (UIColor *)toColorWithDefaultColor:(UIColor *)defaultColor {
	NSString *str = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];

    if ([str contains:@"grouptableviewbackgroundcolor"]) {
        return [UIColor groupTableViewBackgroundColor];
    } else if ([str contains:@"black"]) {
        return [UIColor blackColor];
    } else if ([str contains:@"darkgray"]) {
        return [UIColor darkGrayColor];
    } else if ([str contains:@"lightgray"]) {
        return [UIColor lightGrayColor];
    } else if ([str contains:@"white"]) {
        return [UIColor whiteColor];
    } else if ([str contains:@"gray"]) {
        return [UIColor grayColor];
    } else if ([str contains:@"red"]) {
        return [UIColor redColor];
    } else if ([str contains:@"green"]) {
        return [UIColor greenColor];
    } else if ([str contains:@"blue"]) {
        return [UIColor blueColor];
    } else if ([str contains:@"cyan"]) {
        return [UIColor cyanColor];
    } else if ([str contains:@"yellow"]) {
        return [UIColor yellowColor];
    } else if ([str contains:@"magenta"]) {
        return [UIColor magentaColor];
    } else if ([str contains:@"orange"]) {
        return [UIColor orangeColor];
    } else if ([str contains:@"purple"]) {
        return [UIColor purpleColor];
    } else if ([str contains:@"brown"]) {
        return [UIColor brownColor];
    } else if ([str contains:@"clear"]) {
        return [UIColor clearColor];
    }

	if ([str hasPrefix:@"0x"]){
		str = [str substringFromIndex:2];
	} else if ([str hasPrefix:@"#"]){
		str = [str substringFromIndex:1];
	}

	if ([str length] != 6 && [str length] != 3 && [str length] != 8 && [str length] != 4){
		return defaultColor;
	}

	NSRange range;
	unsigned int r, g, b, a;

	if ([str length] == 3 || [str length] == 4) {
		range.length = 1;
	} else {
		range.length = 2;
	}

	range.location = 0 * range.length;
	if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&r]){
		return defaultColor;
	}

	range.location = 1 * range.length;
	if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&g]){
		return defaultColor;
	}

	range.location = 2 * range.length;
	if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&b]){
		return defaultColor;
	}

	if ([str length] == 4 || [str length] == 8) {
		range.location = 3 * range.length;

		if(![[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&a]){
			return defaultColor;
		}
	} else {
		a = 0;
	}

	if ([str length] == 3 || [str length] == 4) {
        r = (r<<4|r);
        g = (g<<4|r);
        b = (b<<4|r);
        a = (a<<4|r);
    }

	return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:(255.0f - a) / 255.0f];
}

/**
 * 从当前字符串创建一个日期对象
 *
 * @return NSDate
 **/
- (NSDate *)toDate {
	return [NSDate dateFromDateString:self];
}

/**
 * 忽略大小写比较两个字符串
 *
 * @return BOOL
 **/
- (BOOL)equalsIgnoreCase:(NSString *)str {
	if (nil == str) {
		return NO;
	}

	return [[str lowercaseString] isEqualToString:[self lowercaseString]];
}

/* 是否包含特定字符串 */
- (BOOL)contains:(NSString *)str {
	if (nil == str || [str length] < 1) {
		return NO;
	}

	return [self rangeOfString:str].location != NSNotFound;
}

/* 把HTML转换为TEXT文本 */
- (NSString *)html2text {
	NSString *str = [NSString stringWithString:self];

	str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<BR />" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"<b>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<B>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"</b>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"</B>" withString:@" "];

	return str;
}

/* 移除一些HTML标签 */
- (NSString *)striptags {
	NSString *str = [NSString stringWithString:self];

	str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<BR>" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"<BR />" withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];

	return str;
}

/* 格式化文本 */
- (NSString *)textindent {
	NSString *str = [self stringByReplacingOccurrencesOfString:@"\n" withString:@"\n    "];
	str = [NSString stringWithFormat:@"    %@", str];
	return str;
}

/* 获取文本大小 add by yuki */
- (NSString *)NumberSize2StringSize:(NSInteger)numberSize {
    if (numberSize < 1024.0f) {
		return [NSString stringWithFormat:@"%d Bytes", numberSize];
	}else if (numberSize < 1024.0f * 1024.0f) {
		return [NSString stringWithFormat:@"%0.2f KB", (CGFloat)numberSize / 1024.0f];
	}else if (numberSize < 1024.0f * 1024.0f * 1024.0f) {
		return [NSString stringWithFormat:@"%0.2f MB", (CGFloat)numberSize / (1024.0f * 1024.0f)];
	}
    
	return [NSString stringWithFormat:@"%0.2f GB", (CGFloat)numberSize / (1024.0f * 1024.0f * 1024.0f)];
}

//字符串是不是一个纯整数型
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self]; 
    int val; 
    return[scan scanInt:&val] && [scan isAtEnd];
}

/* 获取 UTF8 编码的 NSData 值 */
- (NSData *)toUtf8Data {
    if ([self length] < 1) {
        return [NSData data];
    }

    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

/* 获取中文的第一个首字母 */
+ (NSString *)firstLetter:(NSString *)hanzi
{
    return [NSString stringWithFormat:@"%c",pinyinFirstLetter([hanzi characterAtIndex:0])];
}

/* 获取英文的第一个首字母 */
+ (NSString *)firstLetterEnglish:(NSString *)str
{
    if (!empty(str)) {
        return [str substringWithRange:NSMakeRange(0, 1)];
    }
    return @"#";
}


//获取url里面的参数
- (NSDictionary *)getURLParams{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    NSRange range1  = [self rangeOfString:@"?"];
    NSRange range2  = [self rangeOfString:@"#"];
    NSRange range   ;
    if (range1.location != NSNotFound) {
        range = NSMakeRange(range1.location, range1.length);
    }else if (range2.location != NSNotFound){
        range = NSMakeRange(range2.location, range2.length);
    }else{
        range = NSMakeRange(-1, 1);
    }
    
    if (range.location != NSNotFound) {
        NSString * paramString = [self substringFromIndex:range.location+1];
        NSArray * paramCouples = [paramString componentsSeparatedByString:@"&"];
        for (int i = 0; i < [paramCouples count]; i++) {
            NSArray * param = [[paramCouples objectAtIndex:i] componentsSeparatedByString:@"="];
            if ([param count] == 2) {
                [dic setObject:[[param objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:[[param objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        return dic;
    }
    return nil;
}

// 对字符串添加url参数
- (NSString *)stringByAddingURLParams:(NSDictionary *)params{
    NSString * string           = self;
    
    if (params) {
        NSMutableArray * pairArray  = [NSMutableArray array];
        
        for (NSString * key in params) {
            NSString * value        = [[params objectForKey:key] stringValue];
            NSString * keyEscaped   = [key urlEncoding];
            NSString * valueEscaped = [value urlEncoding];
            NSString * pair         = [NSString stringWithFormat:@"%@=%@",keyEscaped,valueEscaped];
            [pairArray addObject:pair];
        }
        
        NSString * query            = [pairArray componentsJoinedByString:@"&"];
        string                      = [NSString stringWithFormat:@"%@?%@",self,query];
    }
    
    return string;
}


// 根据正则表达式截取字符串
- (NSArray *)getMatchesForRegex:(NSString *)regex{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:1];
    
    NSError * error;
    NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray * matches                = [expression matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    for (int i = 0; i < matches.count; i++) {
        NSTextCheckingResult * result = [matches objectAtIndex:i];
        
        for (int j = 0; j < result.numberOfRanges; j++) {
            NSRange range = [result rangeAtIndex:j];
            NSString * string = [self substringWithRange:range];
            
            [array addObject:string];
        }
    }
    
    return array;
}


// 将字符串中与正则表达式匹配的字符串替换成指定的字符串
- (NSString *)stringByReplaceRegex:(NSString *)regex withString:(NSString *)replace{
    NSError * error;
    NSRegularExpression * expression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSString * string                = [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:replace];
    
    return  string;
}

@end



@implementation NSString (PAPasswordAdditions)
//对密码进行加密
- (NSString *)passwdEncode {
    NSString *md5First =  [self md5];
    NSUInteger lenght = [md5First length];
    NSMutableString * reverse = [[NSMutableString alloc] initWithCapacity:lenght];
    for (NSInteger i = md5First.length-1; i >= 0; i--) {
        [reverse appendFormat:@"%c",[md5First characterAtIndex:i]];
    }
    [reverse appendString:@"paf"];
    NSString *md5Second = [reverse md5];
    return md5Second;
}

@end

@implementation NSString (PACheckValid)

- (BOOL)isValidPhoneNumber {
    NSString *pattern = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";//@"^1[0-9]{10}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    return [regextestmobile evaluateWithObject:self];
}

-(BOOL)isValidateEmail {
    NSString *emailRegex = @"^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((.[a-zA-Z0-9_-]{2,3}){1,2})$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidateWeburl{
    NSString *webRegex = @"^(http|https|www|ftp|)?(://)?(\\w+(-\\w+)*)(\\.(\\w+(-\\w+)*))*((:\\d+)?)(/(\\w+(-\\w+)*))*(\\.?(\\w)*)(\\?)?(((\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*(\\w*%)*(\\w*\\?)*(\\w*:)*(\\w*\\+)*(\\w*\\.)*(\\w*&)*(\\w*-)*(\\w*=)*)*(\\w*)*)$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", webRegex];
    return [emailTest evaluateWithObject:self];
}

// 英文字符，汉字，数字
- (BOOL)isValidNickName {
    if (self.length > 20) {
        return NO;
    }
    NSString *pattern = @"^[\u4e00-\u9fa5a-zA-Z0-9]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL)isValidPasswd  {
    if (self.length < 6 || self.length > 30) {
        return NO;
    }
    NSString *pattern = @"^[a-zA-Z0-9]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL)isValisVerifyCode {
    if (self.length != 6) {
        return NO;
    }
    return YES;
}

//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize minHeight:(CGFloat)minHeight{
    if ([self isEmptyOrWhitespace:str]) {
        return CGSizeMake(maxSize.width, minHeight);
    }
    return [str sizeWithFont:font maxSize:maxSize];
}
@end



@implementation NSString (CurrencyForm)

+ (NSString*) stringWithCurrencyRMBFormWithPrice:(CGFloat)price {
    NSMutableString* value = [[NSMutableString alloc] initWithFormat:@"%.02f", price];
    
    NSRange range = [value rangeOfString:@"."];
    NSInteger index = range.location;
    while (index - 3 > 0) {
        index -= 3;
        [value insertString:@"," atIndex:index++];
    }
    
    [value appendString:@"元"];
    return value;
}

- (UIImage *)imageFromSelf{
    return [UIImage imageNamed:self];
}

+ (NSString*) stringWithCurrencyChineseFormWithPrice:(CGFloat)price {
    NSString* value = nil;
    if (price < 10000.0f) {
        value = [NSString stringWithFormat:@"%.02f元", price];
    } else if (price < 1000000.0f) {
        value = [NSString stringWithFormat:@"%.02f万元", price / 10000.0f];
    } else if (price < 100000000.0f) {
        value = [NSString stringWithFormat:@"%.02f百万元", price / 1000000.0f];
    }
    
    return value;
}

+ (BOOL)isEmptyOrWhitespace:(NSString*)string
{
    if((id)string==[NSNull null] || string==nil || string==NULL)
        return YES;
    
    if(!string)
        return YES;
    
    if(string.length<=0)
        return YES;
    
    if([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length<=0)
        return YES;
    
    return NO;
}

//得到字符串的长度
+(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < text.length; i++) {
        
        
        unichar uc = [text characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}

//屏蔽输入表情
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
