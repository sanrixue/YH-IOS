//
//  MainBaseViewController.h
//  YH-IOS
//
//  Created by li hao on 17/3/30.
//  Copyright © 2017年 com.intfocus. All rights reserved.
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
#import "SubjectViewController.h"
#import "DropViewController.h"
#import "DropTableViewCell.h"
#import "LBXScanView.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "NewSettingViewController.h"
#import "ViewUtils.h"
#import "MainViewController.h"
#import "HomeIndexVC.h"
#import "HomeIndexModel.h"
#import "SuperChartVc.h"
#import "JYHomeViewController.h"


static NSString *const kSubjectSegueIdentifier = @"DashboardToChartSegueIdentifier";
static NSString *const kSettingSegueIdentifier = @"DashboardToSettingSegueIdentifier";

static NSString *const kBannerNameSubjectColumn = @"bannerName";
static NSString *const kLinkSubjectColumn       = @"link";
static NSString *const kObjIDSubjectColumn      = @"objectID";
static NSString *const kObjTypeSubjectColumn    = @"objectType";



@interface MainBaseViewController : MainViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) UIWebView *browser;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (strong, nonatomic) User *user;
@property (assign, nonatomic) CommentObjectType commentObjectType;
// 设置按钮点击下拉菜单
@property (nonatomic, strong) NSArray *dropMenuTitles;
@property (nonatomic, strong) NSArray *dropMenuIcons;
@property (nonatomic, strong) UITableView *dropMenu;


- (void)clearBrowserCache;
- (void)showLoading:(LoadingType)loadingType;

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
- (NSArray *)urlTofilename:(NSString *)url suffix:(NSString *)suffix;
@end
