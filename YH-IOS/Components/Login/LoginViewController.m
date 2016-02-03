//
//  ViewController.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "APIHelper.h"
#import "NSString+MD5.h"
#import <PgyUpdate/PgyUpdateManager.h>

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.assetsPath = [FileUtils sharedPath];
    self.urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, LOGIN_PATH];

    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"LoginViewController - ObjC received message from JS: %@", data);
        responseCallback(@"LoginViewController - Response for message from ObjC");
    }];
    
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        /*
         * 用户行为记录, 单独异常处理，不可影响用户体验
         */
        @try {
            NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
            logParams[@"action"] = @"JS异常";
            logParams[@"obj_title"] = [NSString stringWithFormat:@"登录页面/%@", data[@"ex"]];
            [APIHelper actionLog:logParams];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        
        [self loadHtml];
    }];
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *username = data[@"username"];
        NSString *password = data[@"password"];
        
        if(!username || [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            [self showProgressHUD:@"请输入用户名"];
            self.progressHUD.mode = MBProgressHUDModeText;
            [self.progressHUD hide:YES afterDelay:1.5];
        }
        else if(!password || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            [self showProgressHUD:@"请输入密码"];
            self.progressHUD.mode = MBProgressHUDModeText;
            [self.progressHUD hide:YES afterDelay:1.5];
        }
        else {
            NSString *msg = [APIHelper userAuthentication:username password:password.md5];
            
            if(msg.length == 0) {
                [self checkVersionUpgrade:[FileUtils dirPath:HTML_DIRNAME]];
                [self jumpToDashboardView];
                
                /*
                 * 用户行为记录, 单独异常处理，不可影响用户体验
                 */
                @try {
                    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
                    logParams[@"action"] = @"登录";
                    [APIHelper actionLog:logParams];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception);
                }

            }
            else {
                [self showProgressHUD:msg];
                self.progressHUD.mode = MBProgressHUDModeText;
                [self.progressHUD hide:YES afterDelay:2.0];
            }
        }
    }];

    self.browser.scrollView.scrollEnabled = NO;
    self.browser.scrollView.bounces = NO;
    
    /*
     * 检测登录界面，版本是否升级
     */
    [self checkVersionUpgrade:self.sharedPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadHtml];
    
    //启动检测版本更新
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PGY_APP_ID];
    //[[PgyUpdateManager sharedPgyManager] checkUpdate];
    [[PgyUpdateManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(appUpgradeMethod:)];
}

- (void)dealloc {
    self.browser.delegate = nil;
    self.browser = nil;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
    self.bridge = nil;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)loadHtml {
    [self clearBrowserCache];
    [self showLoading:YES];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([HttpUtils isNetworkAvailable]) {
            HttpResponse *httpResponse = [HttpUtils checkResponseHeader:self.urlString assetsPath:self.assetsPath];

            __block NSString *htmlPath;
            if([httpResponse.statusCode isEqualToNumber:@(200)]) {
                htmlPath = [HttpUtils urlConvertToLocal:self.urlString content:httpResponse.string assetsPath:self.assetsPath writeToLocal:URL_WRITE_LOCAL];
            }
            else {
                NSString *htmlName = [HttpUtils urlTofilename:self.urlString suffix:@".html"][0];
                htmlPath = [self.assetsPath stringByAppendingPathComponent:htmlName];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *htmlContent = [self stringWithContentsOfFile:htmlPath];
                [self.browser loadHTMLString:htmlContent baseURL:[NSURL fileURLWithPath:htmlPath]];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                
                [alert addButton:@"刷新" actionBlock:^(void) {
                    [self loadHtml];
                }];
                    
                [alert showError:self title:@"温馨提示" subTitle:@"网络环境不稳定" closeButtonTitle:@"先这样" duration:0.0f];
            });
        }
    });
}

- (void)jumpToDashboardView {
    UIWindow *window = self.view.window;
    LoginViewController *previousRootViewController = (LoginViewController *)window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    dashboardViewController.fromViewController = @"LoginViewController";
    window.rootViewController = dashboardViewController;
    
    
    // Nasty hack to fix http://stackoverflow.com/questions/26763020/leaking-views-when-changing-rootviewcontroller-inside-transitionwithview
    // The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:self.class]) {
            [subview removeFromSuperview];
        }
    }
    // Allow the view controller to be deallocated
    [previousRootViewController dismissViewControllerAnimated:NO completion:^{
        // Remove the root view in case its still showing
        [previousRootViewController.view removeFromSuperview];
    }];
    
    [self.browser cleanForDealloc];
    self.browser = nil;
    self.browser.delegate = nil;
}

#pragma mark - 缓存当前应用版本，每次检测，不一致时，有所动作
- (void)checkVersionUpgrade:(NSString *)assetsPath {
    NSDictionary *bundleInfo       =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion       = bundleInfo[@"CFBundleShortVersionString"];
    NSString *versionConfigPath    = [NSString stringWithFormat:@"%@/%@", assetsPath, CURRENT_VERSION__FILENAME];
    
    BOOL isUpgrade = NO;
    NSString *localVersion = @"no-exist";
    if([FileUtils checkFileExist:versionConfigPath isDir:NO]) {
        localVersion = [NSString stringWithContentsOfFile:versionConfigPath encoding:NSUTF8StringEncoding error:nil];
        
        if(localVersion && ![localVersion isEqualToString:currentVersion]) {
            isUpgrade = YES;
        }
    }
    else {
        isUpgrade = YES;
    }
    
    if(isUpgrade) {
        NSLog(@"version modified: %@ => %@", localVersion, currentVersion);
        [self removeCachedHeader:assetsPath];
        [currentVersion writeToFile:versionConfigPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:USER_CONFIG_FILENAME];
        NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
        if([userDict.allKeys containsObject:@"assets_md5"]) {
            [userDict removeObjectForKey:@"assets_md5"];
        }
        if([userDict.allKeys containsObject:@"loading_md5"]) {
            [userDict removeObjectForKey:@"loading_md5"];
        }
        [userDict writeToFile:userConfigPath atomically:YES];
        
        NSString *headerPath = [self.sharedPath stringByAppendingPathComponent:CACHED_HEADER_FILENAME];
        [FileUtils removeFile:headerPath];
        
        
        [self checkAssets:@"loading"];
        [self checkAssets:@"assets"];
    }
    
}

- (void)removeCachedHeader:(NSString *)assetsPath {
    NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", assetsPath, CACHED_HEADER_FILENAME];
    NSLog(@"remove header: %@", cachedHeaderPath);
    
    if([FileUtils checkFileExist:cachedHeaderPath isDir:NO]) {
        [FileUtils removeFile:cachedHeaderPath];
    }
}

# pragma mark - 登录界面不支持旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

/**
 *  内容检测版本升级，判断版本号是否为偶数。以便内测
 *
 *  @param response <#response description#>
 */
- (void)appUpgradeMethod:(NSDictionary *)response {
    
    if(response && response[@"downloadURL"] && response[@"versionCode"] && [response[@"versionCode"] integerValue] % 2 == 0) {
        
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"升级" actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        
        [alert showSuccess:self title:@"版本更新" subTitle:response[@"releaseNote"] closeButtonTitle:@"放弃" duration:0.0f];
    }
}
@end
