//
//  BaseView.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "User.h"
#import "HttpUtils.h"
#import "APIHelper.h"
#import "FileUtils+Assets.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>
#import "UIColor+Hex.h"
#import "UIWebview+Clean.h"
#import "LTHPasscodeViewController.h"
#import "ExtendNSLogFunctionality.h"

@interface BaseViewController : UIViewController<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) IBOutlet UILabel *labelTheme;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (strong, nonatomic) User *user;
//@property (weak, nonatomic) IBOutlet UIWebView *browser;

- (void)clearBrowserCache;
- (void)showLoading:(LoadingType)loadingType;
- (void)idColor;

- (void)jumpToLogin;
- (void)showProgressHUD:(NSString *)text;
- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode;

/**
 *  设置是否允许横屏
 *
 *  @param allowRotation 允许横屏
 */
- (void)setAppAllowRotation:(BOOL)allowRotation;

/**
 *  检测服务器端静态文件是否更新
 */
- (void)checkAssetsUpdate;

#pragma mark - LTHPasscode delegate methods
- (void)passcodeWasEnteredSuccessfully;
- (BOOL)didPasscodeTimerEnd;
- (NSString *)passcode;
- (void)savePasscode:(NSString *)passcode;
@end
