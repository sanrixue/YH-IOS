//
//  Constant.h
//  JinXiaoEr
//
//  Created by cjg on 16/11/21.
//
//

#ifndef YHConstant_h
#define YHConstant_h

#ifdef DEBUG
#define DLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define DLog(format, ...)
#endif


/** APP版本号 */
#define APPVERSION 1

#define DEFAULT_IMAGE @"默认图_".imageFromSelf

//屏幕大小宏定义
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_SCALE     (SCREEN_WIDTH/320.0)

/** kvo自动提示宏 */
#define keyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))
#define RGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/** 弱引用宏 */
#define __WEAKSELF __weak __typeof(self) weakSelf = self
/** 单例宏 */
#define ShareInstanceWithClass(CLASS) \
static CLASS * sharedInstance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
sharedInstance = [[CLASS alloc] init]; \
}); \
return sharedInstance;

/** 机型 */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define BaiduYuYinAPI_KEY @"2luLbn7UvyLV5HAG0FVSfQwx" // 请修改为您在百度开发者平台申请的API_KEY
#define BaiduYuYinSECRET_KEY @"6bd2bbba70db7e3e24236ed128c61d01" // 请修改您在百度开发者平台申请的SECRET_KEY
#define BaiduYuYinAPPID @"9207306" // 请修改为您在百度开发者平台申请的APP ID

#pragma mark - 通知名字
#define NotificationDefaultCenter [NSNotificationCenter defaultCenter]

#pragma mark - 偏好设置key
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define ServerPhoneKey @"consumer_hotline" // 客服电话key

#endif /* Constant_h */
