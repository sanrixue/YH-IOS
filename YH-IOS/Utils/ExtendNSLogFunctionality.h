//
//  ExtendNSLogFunctionality..h
//  iReorganize
//
//  Created by lijunjie on 15/5/20.
//  Copyright (c) 2015年 Intfocus. All rights reserved.
//
//  Reference:
//
//  [Quick Tip: Customize NSLog for Easier Debugging](http://code.tutsplus.com/tutorials/quick-tip-customize-nslog-for-easier-debugging--mobile-19066)

#ifndef ExtendNSLogFunctionality__h
#define ExtendNSLogFunctionality__h

#pragma mark - AppDelegate.h
#import "AppDelegate.h"
#define kAppDelegate ((AppDelegate *)([UIApplication sharedApplication].delegate))

#pragma mark - 屏幕相关
#define IS_SCREEN_5_5_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_4_7_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_4_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_SCREEN_3_5_INCH	([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define kBannerHeight (IS_SCREEN_5_5_INCH ? 74 : 64)
#define kTabBarHeight (IS_SCREEN_5_5_INCH ? 56 : 49)

#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)

#define kBannerHeight (IS_SCREEN_5_5_INCH ? 74 : 64)
#define KTabBarHeight (IS_SCREEN_5_5_INCH ? 56 : 49)
// 相对宽度为320屏幕的屏幕倍率
#define kScreenWidthRate (kScreenWidth/320.0)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#pragma mark - 系统版本相关
#define iOSVersion                        [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS7Later                         (iOSVersion >= 7.0)
#define iOS8Later                         (iOSVersion >= 8.0)

#pragma mark - weakSelf
#define WS(weakSelf)   __weak __typeof(&*self)weakSelf = self;

#pragma mark - Log
#define XCODE_COLORS_ESCAPE @"\033["
#define Color(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define DLogRect(rect)  DLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y,rect.size.width, rect.size.height)
#   define DLogPoint(pt) DLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)
#   define DLogSize(size) DLog(@"%s w=%f, h=%f", #size, size.width, size.height)
#   define ALog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }

#   define LogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#   define LogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#   define LogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

#   else
#   define DLog(...)
#   define DLogRect(rect)
#   define DLogPoint(pt)
#   define DLogSize(size)
#   define ALog(...)
#   define LogBlue(...)
#   define LogRed(...)
#   define LogGreen(...)
#   endif

#import <Foundation/Foundation.h>
#import "DateUtils.h"
#import "HttpUtils.h"
#import "Constant.h"

//#ifdef DEBUG
//#  define NSLog(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
//#else
//#  define NSLog(x...)
//#endif

#ifdef DEBUG_ERROR
#  define NSErrorPrint(error, args...) ExtendNSLogPrintError(__FILE__,__LINE__,__PRETTY_FUNCTION__, true, error, args);
#else
#  define NSErrorPrint(error, args...) ExtendNSLogPrintError(__FILE__,__LINE__,__PRETTY_FUNCTION__, false, error, args);
#endif


#define psd(pValue, dValue) propertyDefault(pValue, dValue)

BOOL isNULL(NSObject *propertyValue);
void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);
BOOL ExtendNSLogPrintError(const char *file, int lineNumber, const char *functionName,BOOL isPrintSuccessfully, NSError *error, NSString *format, ...);
void actionLogPost(const char *sourceFile, int lineNumber, const char *functionName, NSString *actionName, NSString *actionResult);
NSObject* propertyDefault(NSObject *propertyValue, NSObject *defaultVlaue);

#endif
