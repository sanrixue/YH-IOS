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
#import "UMessage.h"
#import "Version.h"

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.assetsPath = [FileUtils sharedPath];

    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.browser webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"LoginViewController - ObjC received message from JS: %@", data);
        responseCallback(@"LoginViewController - Response for message from ObjC");
    }];
    
    [self.bridge registerHandler:@"jsException" handler:^(id data, WVJBResponseCallback responseCallback) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
        });
    }];
    
    [self.bridge registerHandler:@"refreshBrowser" handler:^(id data, WVJBResponseCallback responseCallback) {
        [HttpUtils clearHttpResponeHeader:self.urlString assetsPath:self.assetsPath];
        
        [self showLoading:LoadingLogin];
    }];
    
    [self.bridge registerHandler:@"iosCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *usernum  = data[@"username"];
        NSString *password = data[@"password"];
        
        if(!usernum || [usernum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            [self showProgressHUD:@"请输入用户名" mode: MBProgressHUDModeText];
            [self.progressHUD hide:YES afterDelay:1.5];
        }
        else if(!password || [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
            [self showProgressHUD:@"请输入密码" mode: MBProgressHUDModeText];
            [self.progressHUD hide:YES afterDelay:1.5];
        }
        else {
            [self showProgressHUD:@"验证中..."];
            
            NSString *msg = [APIHelper userAuthentication:usernum password:password.md5];
            [self.progressHUD hide:YES];
            
            if(msg.length == 0) {
                [self showProgressHUD:@"跳转中..."];

                [self checkVersionUpgrade:[FileUtils dirPath:HTML_DIRNAME]];
                [self.browser stopLoading];
                [self clearBrowserCache];
                [self jumpToDashboardView];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @try {
                        // 友盟消息推送-标签设置（先删除，再添加）
                        [UMessage removeAllTags:^(id responseObject, NSInteger remain, NSError *error) {
                            NSLog(@"response: %@\nerror: %@", responseObject, error);
                        }];
                        [UMessage addTag:[User APNsTags] response:^(id responseObject, NSInteger remain, NSError *error) {
                            NSLog(@"addTag response: %@\nerror: %@", responseObject, error);
                        }];
                        [UMessage setAlias:[User APNsAlias] type:kUMessageAliasTypeSina response:^(id responseObject, NSError *error) {
                            NSLog(@"setAlias response: %@\nerror: %@", responseObject, error);
                        }];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"umeng - %@", exception);
                    }
                    
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
                });
            }
            else {
                [self showProgressHUD:msg mode: MBProgressHUDModeText];
                [self.progressHUD hide:YES afterDelay:2.0];
            }
        }
    }];

    self.browser.scrollView.scrollEnabled = NO;
    self.browser.scrollView.bounces = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    /*
     * 检测登录界面，版本是否升级
     */
    [self checkVersionUpgrade:self.sharedPath];
    
    /**
     *  检查本地静态资源是否解压
     */
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    [FileUtils checkAssets:@"assets" isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:@"loading" isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:@"fonts" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"images" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"javascripts" isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"stylesheets" isInAssets:YES bundlePath:bundlePath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showLoading:LoadingLogin];
    
    //启动检测版本更新
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
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

- (void)jumpToDashboardView {
    UIWindow *window = self.view.window;
    LoginViewController *previousRootViewController = (LoginViewController *)window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    dashboardViewController.fromViewController = @"LoginViewController";
    window.rootViewController = dashboardViewController;
    [self.progressHUD hide:YES];
    
    
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
    
    BOOL isUpgrade = YES;
    NSString *localVersion = @"no-exist";
    if([FileUtils checkFileExist:versionConfigPath isDir:NO]) {
        localVersion = [NSString stringWithContentsOfFile:versionConfigPath encoding:NSUTF8StringEncoding error:nil];
        
        if(localVersion && [localVersion isEqualToString:currentVersion]) {
            isUpgrade = NO;
        }
    }
    
    if(isUpgrade) {
        NSLog(@"version modified: %@ => %@", localVersion, currentVersion);
        NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", assetsPath, CACHED_HEADER_FILENAME];
        [FileUtils removeFile:cachedHeaderPath];
        NSLog(@"remove header: %@", cachedHeaderPath);
        
        [currentVersion writeToFile:versionConfigPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
    NSString *pgyerVersionPath = [[FileUtils basePath] stringByAppendingPathComponent:PGYER_VERSION_FILENAME];
    [FileUtils writeJSON:[NSMutableDictionary dictionaryWithDictionary:response] Into:pgyerVersionPath];
    
    if(!response || !response[@"downloadURL"] || !response[@"versionCode"] || !response[@"versionName"]) return;
    
    Version *version = [[Version alloc] init];
    BOOL isPgyerLatest = [version.current isEqualToString:response[@"versionName"]] && [version.build isEqualToString:response[@"versionCode"]];
    if(!isPgyerLatest && [response[@"versionCode"] integerValue] % 2 == 0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"升级" actionBlock:^(void) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"downloadURL"]]];
            [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
        }];
        
        NSString *subTitle = [NSString stringWithFormat:@"更新到版本: %@(%@)", response[@"versionName"], response[@"versionCode"]];
        [alert showSuccess:self title:@"版本更新" subTitle:subTitle closeButtonTitle:@"放弃" duration:0.0f];
    }
}
@end
