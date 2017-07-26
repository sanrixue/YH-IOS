//
//  ResetPasswordViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/12/29.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//
//可能已弃用
#import "ResetPasswordViewController.h"
#import "APIHelper.h"
#import "HttpResponse.h"
#import "NSString+MD5.h"
#import "ViewUtils.h"
#import "WebViewJavascriptBridge.h"
#import "UIColor+Hex.h"
#import <SCLAlertView.h>
#import "FileUtils.h"
#import "FileUtils+Assets.h"
#import "User.h"
#import "LoginViewController.h"

@interface ResetPasswordViewController()<UIWebViewDelegate>
@property WebViewJavascriptBridge* bridge;
@property (strong, nonatomic) UIWebView *browser;
@property (strong, nonatomic) MBProgressHUD *progressHUD;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *assetsPath;
@property (strong, nonatomic) NSString *sharedPath;
@property (strong, nonatomic) User* user;

@end

@implementation ResetPasswordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.browser = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.browser];
    [WebViewJavascriptBridge enableLogging];
    [self.navigationController setNavigationBarHidden:false];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //@{}代表Dictionary
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kThemeColor];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 44, 40)];
    UIImage *imageback = [[UIImage imageNamed:@"Banner-Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *bakImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    bakImage.image = imageback;
    [bakImage setContentMode:UIViewContentModeScaleAspectFit];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn addSubview:bakImage];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -20;
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *leftItem =  [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
   
    
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ResetPasswordViewController - ObjC received message from JS: %@", data);
        responseCallback(@"ResetPasswordViewController - Response for message from ObjC");
    }];
    self.user = [[User alloc]init];
    if(self.user.userID) {
        self.assetsPath = [FileUtils dirPath:kHTMLDirName];
    }
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @try {
                NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                logParams[@"action"] = @"JS异常";
                logParams[@"obj_title"] = [NSString stringWithFormat:@"重置密码页面/%@", data[@"ex"]];
                [APIHelper actionLog:logParams];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception);
            }
        });
    }];
    
    [self.bridge registerHandler:@"ResetPassword" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *oldPassword = data[@"oldPassword"];
        NSString *newPassword = data[@"newPassword"];
        NSLog(@"%@,%@", oldPassword, newPassword);
        
        if([oldPassword.md5 isEqualToString:self.user.password]) {
            
            HttpResponse *response = [APIHelper resetPassword:self.user.userID newPassword:newPassword.md5];
            NSString *message = [NSString stringWithFormat:@"%@", response.data[@"info"]];
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            if(response.statusCode && [response.statusCode isEqualToNumber:@(201)]) {
                [self changLocalPwd:newPassword];
                [alert addButton:@"重新登录" actionBlock:^(void) {
                    [self jumpToLogin];
                }];
                
                [alert showSuccess:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    /*
                     * 用户行为记录, 单独异常处理，不可影响用户体验
                     */
                    @try {
                        NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                        logParams[@"action"] = @"重置密码";
                        [APIHelper actionLog:logParams];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"%@", exception);
                    }
                });
 
            }
            else {
               // [self changLocalPwd:newPassword];
                [alert addButton:@"好的" actionBlock:^(void) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        self.browser.delegate = nil;
                        self.browser = nil;
                        [self.progressHUD hide:YES];
                        self.progressHUD = nil;
                        self.bridge = nil;
                    }];
                }];
                [alert showWarning:self title:@"温馨提示" subTitle:message closeButtonTitle:nil duration:0.0f];
            }
        }
        else {
            [ViewUtils showPopupView:self.view Info:@"原始密码输入有误"];
            [self loadHtml];
        }
    }];

    self.urlString = [NSString stringWithFormat:kResetPwdMobilePath, kBaseUrl, [FileUtils currentUIVersion]];
}

// 支持设备自动旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

// 支持竖屏显示
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadHtml];
}


- (void)backAction{
    if (self.navigationController && self.childViewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[kIsLoginCUName] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kMainSBName bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:kLoginVCName];
    self.view.window.rootViewController = loginViewController;
}

- (void)changLocalPwd:(NSString *)newPassword {
    NSString  *noticeFilePath = [FileUtils dirPath:@"Cached" FileName:@"local_notifition.json"];
    NSMutableDictionary *noticeDict = [FileUtils readConfigFile:noticeFilePath];
    noticeDict[@"setting_password"] = @(-1);
    noticeDict[@"setting"] = @(0);
    [FileUtils writeJSON:noticeDict Into:noticeFilePath];
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"user_md5"] = newPassword.md5;
    [FileUtils writeJSON:userDict Into:userConfigPath];
}

- (void)dealloc {
    [self.browser stopLoading];
    [self.browser cleanForDealloc];
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}

#pragma mark - assistant methods
- (void)loadHtml {
    DeviceState deviceState = [APIHelper deviceState];
    if(deviceState == StateOK) {
        [self _loadHtml];
    }
    else if(deviceState == StateForbid) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert addButton:@"知道了" actionBlock:^(void) {
            [self jumpToLogin];
        }];
        
        [alert showError:self title:@"温馨提示" subTitle:@"您被禁止在该设备使用本应用" closeButtonTitle:nil duration:0.0f];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLoading:LoadingRefresh];
        });
    }
}

- (void)_loadHtml {
    
    [self showLoading:LoadingLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];
        
        __block NSString *htmlPath;
        if([httpResponse.statusCode isEqualToNumber:@(200)]) {
            htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:kIsUrlWrite2Local];
        }
        else {
            NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
            htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self clearBrowserCache];
            NSString *htmlContent = [FileUtils loadLocalAssetsWithPath:htmlPath];
            [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:[FileUtils sharedPath]]];
        });
    });
}

- (void)clearBrowserCache {
    [self.browser stopLoading];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSString *domain = [[NSURL URLWithString:self.urlString] host];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if([[cookie domain] isEqualToString:domain]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

- (void)showLoading:(LoadingType)loadingType {
    NSString *loadingPath = [FileUtils loadingPath:loadingType];
    NSString *loadingContent = [NSString stringWithContentsOfFile:loadingPath encoding:NSUTF8StringEncoding error:nil];
    [self.browser loadHTMLString:loadingContent baseURL:[NSURL fileURLWithPath:loadingPath]];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate date]];
}

@end
