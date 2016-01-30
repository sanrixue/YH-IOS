//
//  BaseView.h
//  YH-IOS
//
//  Created by lijunjie on 15/12/2.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "const.h"
#import "FileUtils.h"
#import "HttpUtils.h"
#import "APIHelper.h"
#import <MBProgressHUD.h>
#import "WebViewJavascriptBridge.h"
#import "HttpResponse.h"
#import <SCLAlertView.h>
#import "UIColor+Hex.h"
#import "User.h"
#import "UIWebview+Clean.h"

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
@property (strong, nonatomic) User *user;

- (NSString *)stringWithContentsOfFile:(NSString *)htmlPath;
- (void)clearBrowserCache;
- (void)showLoading;
- (void)showLoading:(BOOL)isLogin;
- (void)idColor;

- (void)jumpToLogin;
- (void)showProgressHUD:(NSString *)text;
/*
 *  内容检测版本升级，判断版本号是否为偶数。以便内测
 *
 *  @param response <#response description#>
 */
- (void)appUpgradeMethod:(NSDictionary *)response;

/**
 *  检测静态文件
 *
 *  @param fileName <#fileName description#>
 */
- (void)checkAssets:(NSString *)fileName;

@end
