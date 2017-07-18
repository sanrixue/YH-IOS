//
//  AppDelegate.m
//  YH-IOS
//
//  Created by lijunjie on 15/11/23.
//  Copyright © 2015年 com.intfocus. All rights reserved.
//

#import "AppDelegate.h"
#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "Constant.h"
#import "NSData+MD5.h"
#import <PgySDK/PgyManager.h>
#import "Version.h"
#import "FileUtils+Assets.h"
#import "MianTabBarViewController.h"

#import "DashboardViewController.h"
#import "LoginViewController.h"
#import "LTHPasscodeViewController.h"
#import "ThurSayViewController.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import <UserNotifications/UserNotifications.h>
#import "GuidePageViewController.h"


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

@interface AppDelegate ()<LTHPasscodeViewControllerDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic,assign) BOOL isReApp;
@end

@implementation AppDelegate

void UncaughtExceptionHandler(NSException * exception) {
    NSArray *arr     = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name   = [exception name];
    Version *version = [[Version alloc] init];
    NSString *mailContent = [NSString stringWithFormat:@"mailto:jay_li@intfocus.com \
                             ?subject=%@客户端 BUG 报告                                 \
                             &body=很抱歉%@应用出现故障,发送这封邮件可协助我们改善此应用<br> \
                             感谢您的配合!<br><br>                                     \
                             应用详情:<br>                                            \
                             %@<br>                                                  \
                             错误详情:<br>                                            \
                             %@<br>                                                  \
                             --------------------------<br>                          \
                             %@<br>                                                  \
                             --------------------------<br>                          \
                             %@",
                             version.appName, version.appName,
                             [version simpleDescription],
                             name,reason,[arr componentsJoinedByString:@"<br>"]];
    
    NSURL *url = [NSURL URLWithString:[mailContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
}

+ (AppDelegate *)shareAppdelegate{
    return [UIApplication sharedApplication].delegate;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.allowRotation == YES) {
        
        return UIInterfaceOrientationMaskAll;
        
    }else{
        
        return UIInterfaceOrientationMaskPortrait;
        
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _isReApp = YES;
    // [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"receiveRemote"];
    // 获取版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *initViewController = [storyBoard instantiateInitialViewController];
    NSString *old_Version =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"firstStart"]];
    if([old_Version isEqual:nil] || ![app_Version isEqualToString:old_Version] ){
        NSString* sharedPath = [FileUtils sharedPath];
        NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", sharedPath, kCachedHeaderConfigFileName];
        [FileUtils removeFile:cachedHeaderPath];
        NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
        if ([FileUtils checkFileExist:userConfigPath isDir:NO]) {
            [FileUtils removeFile:userConfigPath];
        }
        NSString* assetsPath = [sharedPath stringByAppendingPathComponent:@"assets"];
        [FileUtils removeFile:assetsPath];
        cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils dirPath:kHTMLDirName], kCachedHeaderConfigFileName];
        [[NSUserDefaults standardUserDefaults] setObject:app_Version forKey:@"firstStart"];
        GuidePageViewController *guidePage = [[GuidePageViewController alloc]init];
        [self.window setRootViewController:guidePage];
        [FileUtils removeFile:cachedHeaderPath];
         NSString *distPath = [[FileUtils sharedPath] stringByAppendingPathComponent:@"dist"];
        if ([ FileUtils checkFileExist:distPath isDir:YES]) {
            [FileUtils removeFile:distPath];
        }
    }else{
        [self.window setRootViewController:initViewController];
    }
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if(userInfo){//推送信息
       NSDictionary* userInfo1  = [userInfo copy];//[userInfo copy]
        NSLog(@"%@",userInfo);
    }
    
    //[self.window setRootViewController:initViewController];
    [self.window makeKeyAndVisible];
    NSString *initString  = [NSString stringWithFormat:@"appid = %@",@"581aad1c"];
    [IFlySpeechUtility createUtility:initString];
    [self initPgyer];
    [self initUMessage:launchOptions];
    [self initUMSocial];
    [self checkVersionUpgrade];
    [self checkAssets];
    [self initWebViewUserAgent];
    [self initScreenLock];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    application.applicationIconBadgeNumber = 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (IOS10_OR_LATER) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate =self;
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        content.title= @"新消息";
        content.sound = [UNNotificationSound defaultSound];
        
        //  UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        
        //  UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"com.intfocus.mcre" content:content trigger:trigger];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionCarPlay | UNAuthorizationOptionSound | UNAuthorizationOptionBadge | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            if (granted) {
                NSLog(@" iOS 10 request notification success");
            }else{
                NSLog(@" iOS 10 request notification fail");
            }
        }];
        //  [center addNotificationRequest:request withCompletionHandler:nil];
    }
    else if (IOS8_OR_LATER)
    {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    return YES;
}

- (void)savePushDict:(NSDictionary *)dict {
    if(!dict) { return; }
    
    NSMutableDictionary *pushMessageDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    pushMessageDict[kStatePushColumn] = @(NO);
    NSString *pushConfigPath= [[FileUtils basePath] stringByAppendingPathComponent:kPushMessageFileName];
    [pushMessageDict writeToFile:pushConfigPath atomically:YES];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    NSString *pushToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                           stringByReplacingOccurrencesOfString: @">" withString: @""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
    NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
    if(pushToken.length != 64 || (pushDict[@"push_valid"] && [pushDict[@"push_valid"] boolValue])) {
        return;
    }
    
    pushDict[@"push_device_token"] = pushToken;
    pushDict[@"push_valid"] = @(NO);
    [pushDict writeToFile:pushConfigPath atomically:YES];
    NSLog(@"设备%@",pushToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

/**
 *  <#Description#>
 *
     push_message: { // 服务器参数
         type: report,
         title: '16年第三季度季报'
         url: 'report-link’, // 与 API 链接格式相同
         obj_id: 1,
         obj_type: 1
     },
     state: true_or_false // 接收参数时设置为 `false`
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self savePushDict:userInfo];
    NSString *pushConfigPath = [[FileUtils userspace] stringByAppendingPathComponent:@"receiveRemote"];
    [userInfo writeToFile:pushConfigPath atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remotepush" object:nil userInfo:userInfo];
    [[NSUserDefaults standardUserDefaults]  setBool:YES forKey:@"receiveRemote"];
    // 关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive) {
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:kWarningTitleText message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:kCancelBtnText otherButtonTitles:kViewInstantBtnText,nil];
        [alertView show];
    }
    else{
        [self checkIsLoginThenJump];
    }
}


- (void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    /* SystemSoundID soundID = 1008;//具体参数详情下面贴出来
     //播放声音
     AudioServicesPlaySystemSound(soundID);*/
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSString *pushConfigPath = [[FileUtils userspace] stringByAppendingPathComponent:@"receiveRemote"];
    [userInfo writeToFile:pushConfigPath atomically:YES];
     [self checkIsLoginThenJump];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"remotepush" object:nil];
}

#pragma mark - 程序在运行时候接收到通知
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self checkIsLoginThenJump];
        //[alertView removeFromSuperview];
    }
}
// 获取当前页面显示的类
- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    result = [nextResponder isKindOfClass:[UIViewController class]] ? nextResponder : window.rootViewController;
    return result;
}

- (void)jumpToThurSay {
    if ([[self getCurrentVC] isMemberOfClass:[LoginViewController class]]) {
        return;
    }
    if (![[self getCurrentVC] isMemberOfClass:[ThurSayViewController class]]) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [self jumpToDashboardView];
}

- (void)checkIsLoginThenJump {
    [self isLogin] ? [self jumpToThurSay] : [self jumpToLogin];
}

#pragma mark - 跳转至仪表盘
- (void)jumpToDashboardView {
    LoginViewController *previousRootViewController = (LoginViewController *)_window.rootViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  //  DashboardViewController *dashboardViewController = [storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    // dashboardViewController.clickTab = self.clickTab;
    //dashboardViewController.fromViewController = @"LoginViewController";
      MianTabBarViewController *mainTabbar = [[MianTabBarViewController alloc]init];
    _window.rootViewController = mainTabbar;
    // Nasty hack to fix http://stackoverflow.com/questions/26763020/leaking-views-when-changing-rootviewcontroller-inside-transitionwithview
    // The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
    for (UIView *subview in _window.subviews) {
        if ([subview isKindOfClass:self.class]) {
            [subview removeFromSuperview];
        }
    }
    // Allow the view controller to be deallocated
    [previousRootViewController dismissViewControllerAnimated:NO completion:^{
        // Remove the root view in case its still showing
        [previousRootViewController.view removeFromSuperview];
    }];
}

#pragma mark - 判断用户是否登录
- (BOOL)isLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    return [userDict[@"is_login"] boolValue];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self initScreenLock];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - LTHPasscodeViewControllerDelegate methods
- (void)passcodeWasEnteredSuccessfully {
    NSLog(@"AppDelegate - Passcode Was Entered Successfully");
    
    if (![self isLogin]) {
        [self jumpToLogin];
    }
    else {
        if (_isReApp) {
           [self jumpToDashboardView];
            _isReApp = NO;
        }
    }
    NSMutableDictionary *logParams = [NSMutableDictionary dictionary];
    logParams[kActionALCName]   = [NSString stringWithFormat:@"解锁"];
    [APIHelper actionLog:logParams];
  //  MianTabBarViewController *mainTabbar = [[MianTabBarViewController alloc]init];
    //_window.rootViewController = mainTabbar;
}

- (BOOL)didPasscodeTimerEnd {
    return YES;
}

- (NSString *)passcode {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    if([userDict[@"is_login"] boolValue] && [userDict[@"use_gesture_password"] boolValue]) {
        return userDict[@"gesture_password"] ?: @"";
    }
    return @"";
}
 

- (void)jumpToLogin {
    NSString *userConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserConfigFileName];
    NSMutableDictionary *userDict = [FileUtils readConfigFile:userConfigPath];
    userDict[@"is_login"] = @(NO);
    [userDict writeToFile:userConfigPath atomically:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.window.rootViewController = loginViewController;
}

#pragma mark - 缓存当前应用版本，每次检测，不一致时，有所动作
/**
 *  应用版本更新后，拷贝静态资源至sharedPath/下
 *
 *  注意: 需在 [FileUtils checkAssets:isInAssets:bundlePath:; 操作之前
 *  本次操作只拷贝覆盖， 解压等操作由FileUtils来完成
 *
 *  @param assetsPath <#assetsPath description#>
 */
- (void)checkVersionUpgrade {
    NSError *error;
    NSDictionary *bundleInfo       =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion       = bundleInfo[@"CFBundleShortVersionString"];
    NSString *versionConfigPath    = [NSString stringWithFormat:@"%@/%@", [FileUtils basePath], kCurrentVersionFileName];
    
    BOOL isUpgrade = YES;
    NSString *localVersion = @"noexist";
    if([FileUtils checkFileExist:versionConfigPath isDir:NO]) {
        localVersion = [NSString stringWithContentsOfFile:versionConfigPath encoding:NSUTF8StringEncoding error:nil];
        
        if(localVersion && [localVersion isEqualToString:currentVersion]) {
            isUpgrade = NO;
        }
    }
    
    if(isUpgrade) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *sharedPath = [FileUtils sharedPath], *bundleZipPath, *zipPath, *assetFileName;
        for(NSString *assetName in @[kAssetsAssetsName, kLoadingAssetsName, kFontsAssetsName, kImagesAssetsName, kStylesheetsAssetsName, kJavascriptsAssetsName, kBarCodeScanAssetsName]) { // kAdvertisementAssetsName
            assetFileName = [NSString stringWithFormat:@"%@.zip", assetName];
            bundleZipPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:assetFileName];
            zipPath = [sharedPath stringByAppendingPathComponent:assetFileName];
            NSString *cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils sharedPath], kCachedHeaderConfigFileName];
            [FileUtils removeFile:cachedHeaderPath];
            cachedHeaderPath  = [NSString stringWithFormat:@"%@/%@", [FileUtils dirPath:kHTMLDirName], kCachedHeaderConfigFileName];
            [FileUtils removeFile:cachedHeaderPath];
            NSLog(@"version updated: %@ => %@", bundleZipPath, zipPath);
            if([FileUtils checkFileExist:zipPath isDir:NO]) {
                [fileManager removeItemAtPath:zipPath error:&error];
                if(error) { NSLog(@"%@", [error localizedDescription]); }
            }
            [fileManager copyItemAtPath:bundleZipPath toPath:zipPath error:&error];
            if(error) { NSLog(@"%@", [error localizedDescription]); }
        }

        [currentVersion writeToFile:versionConfigPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        // 消息推送，重新上传服务器
        NSString *pushConfigPath = [[FileUtils basePath] stringByAppendingPathComponent:kPushConfigFileName];
        NSMutableDictionary *pushDict = [FileUtils readConfigFile:pushConfigPath];
        pushDict[@"push_valid"] = @(NO);
        [pushDict writeToFile:pushConfigPath atomically:YES];
    }
}

- (void)checkAssets {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    [FileUtils checkAssets:kAssetsAssetsName isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:kLoadingAssetsName isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:kFontsAssetsName isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:kImagesAssetsName isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:kJavascriptsAssetsName isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:kStylesheetsAssetsName isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:kBarCodeScanAssetsName isInAssets:NO bundlePath:bundlePath];
    [FileUtils checkAssets:kIconsAssetsName isInAssets:YES bundlePath:bundlePath];
    [FileUtils checkAssets:@"dist" isInAssets:NO bundlePath:bundlePath];
    // [FileUtils checkAssets:kAdvertisementAssetsName isInAssets:NO bundlePath:bundlePath];
}

- (void)initWebViewUserAgent {
    NSString *userAgentPath = [[FileUtils basePath] stringByAppendingPathComponent:kUserAgentFileName];
    if(![FileUtils checkFileExist:userAgentPath isDir:NO]) {
        UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        [userAgent writeToFile:userAgentPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)initScreenLock {
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController useKeychain:NO];
    [LTHPasscodeViewController sharedUser].allowUnlockWithTouchID = NO;
    if ([LTHPasscodeViewController doesPasscodeExist] && [LTHPasscodeViewController didPasscodeTimerEnd]) {
        [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES withLogout:NO andLogoutTitle:nil];
    }
}

#pragma mark - initialized SDK
- (void)initPgyer {
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyManager sharedPgyManager] startManagerWithAppId:kPgyerAppId];
}

- (void)initUMessage:(NSDictionary *)launchOptions {
    [UMessage startWithAppkey:kUMAppId launchOptions:launchOptions];
    // [UMessage setChannel:@"App Store"];
    
    //register remoteNotification types （iOS 8.0及其以上版本）
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"action1_identifier";
    action1.title= @"Accept";
    action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
    action2.identifier = @"action2_identifier";
    action2.title= @"Reject";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    categorys.identifier = @"category1";//这组动作的唯一标示
    [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
    
    UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                 categories:[NSSet setWithObject:categorys]];
    [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    
    [UMessage setLogEnabled:YES];
    [UMessage setBadgeClear:NO];
}

- (void)initUMSocial {
    [UMSocialData setAppKey:kUMAppId];
    [UMSocialData openLog:YES];
    // 如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:kBaseUrl];
}

#pragma mark - UMeng Social Callback
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
@end
