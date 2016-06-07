//
//  BaseView.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constant.h"
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

@interface BaseViewController : UIViewController<UIWebViewDelegate>

@property WebViewJavascriptBridge* bridge;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIWebView *browser;
@property (weak, nonatomic) IBOutlet UILabel *labelTheme;
@property (weak, nonatomic) IBOutlet UIView *idView;
@property (weak, nonatomic) IBOutlet UIImageView *idColor0;
@property (weak, nonatomic) IBOutlet UIImageView *idColor1;
@property (weak, nonatomic) IBOutlet UIImageView *idColor2;
@property (weak, nonatomic) IBOutlet UIImageView *idColor3;
@property (weak, nonatomic) IBOutlet UIImageView *idColor4;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (strong, nonatomic) User *user;

- (NSString *)stringWithContentsOfFile:(NSString *)htmlPath;
- (void)clearBrowserCache;
- (void)showLoading:(LoadingType)loadingType;
- (void)idColor;

- (void)jumpToLogin;
- (void)showProgressHUD:(NSString *)text;
- (void)showProgressHUD:(NSString *)text mode:(MBProgressHUDMode)mode;
/*
 *  内容检测版本升级，判断版本号是否为偶数。以便内测
 *
 *  @param response <#response description#>
 */
- (void)appUpgradeMethod:(NSDictionary *)response;

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
- (NSString *)currentUIVersion;

@end
